#!/bin/sh
# Bootstrap a fresh Mac. Each step is independent — failures don't cascade.
# Re-runnable: skips steps that are already done.

MACHINE_TYPE="${1:-}"
if [ -z "$MACHINE_TYPE" ]; then
    printf "Machine type (laptop/nas): "
    read MACHINE_TYPE < /dev/tty
fi

case "$MACHINE_TYPE" in
    laptop|nas) ;;
    *) echo "Invalid machine type: $MACHINE_TYPE"; exit 1 ;;
esac

DOTFILES_DIR="$HOME/dotfiles"
FAIL=0

ok()   { echo "  OK  $1"; }
fail() { echo "  FAIL  $1"; FAIL=1; }

# 1. Homebrew
echo "[1] Homebrew..."
if command -v brew >/dev/null 2>&1; then
    ok "already installed"
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && ok "installed" || fail "install failed"
fi
BREW_BIN=""
for p in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [ -x "$p" ] && BREW_BIN="$p" && break
done
[ -n "$BREW_BIN" ] && eval "$("$BREW_BIN" shellenv)"

# 2. Clone dotfiles
echo "[2] Clone dotfiles..."
if [ -d "$DOTFILES_DIR/.git" ]; then
    ok "already cloned"
else
    git clone https://github.com/sasha-computer/dotfiles.git "$DOTFILES_DIR" && ok "cloned" || fail "clone failed"
fi

# 3. Symlink config files
echo "[3] Symlink config..."
sh "$DOTFILES_DIR/scripts/symlink.sh" && ok "symlinked" || fail "symlink failed"

# 4. Install packages
echo "[4] Packages..."
if [ -f "$DOTFILES_DIR/Brewfile.$MACHINE_TYPE" ]; then
    brew bundle install --file "$DOTFILES_DIR/Brewfile.$MACHINE_TYPE" && ok "installed" || fail "some packages failed (re-run: brew bundle install --file ~/dotfiles/Brewfile.$MACHINE_TYPE)"
else
    fail "Brewfile.$MACHINE_TYPE not found"
fi

# 5. macOS defaults
echo "[5] macOS defaults..."
sh "$DOTFILES_DIR/scripts/macos-defaults.sh" && ok "applied" || fail "defaults failed"

# 6. Set login shell to fish
echo "[6] Login shell..."
FISH_PATH=""
for p in /opt/homebrew/bin/fish /usr/local/bin/fish; do
    [ -x "$p" ] && FISH_PATH="$p" && break
done
CURRENT_SHELL=$(dscl . -read "$HOME" UserShell 2>/dev/null | awk '{print $2}')
if [ "$CURRENT_SHELL" = "$FISH_PATH" ]; then
    ok "already fish"
elif [ -n "$FISH_PATH" ]; then
    grep -qx "$FISH_PATH" /etc/shells 2>/dev/null || echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
    chsh -s "$FISH_PATH" && ok "set to fish" || fail "chsh failed"
else
    fail "fish not installed (brew bundle may have partially failed)"
fi

# 7. LazyVim
echo "[7] LazyVim..."
if [ -d "$HOME/.config/nvim" ]; then
    ok "already installed"
else
    git clone https://github.com/LazyVim/starter "$HOME/.config/nvim" \
        && rm -rf "$HOME/.config/nvim/.git" \
        && ok "installed" || fail "clone failed"
fi

# 8. Fisher plugins
echo "[8] Fisher..."
if command -v fish >/dev/null 2>&1; then
    fish "$DOTFILES_DIR/scripts/bootstrap-fish.fish" && ok "installed" || fail "Fisher failed"
else
    fail "fish not installed"
fi

# 9. Global tools (laptop only)
if [ "$MACHINE_TYPE" = "laptop" ]; then
    echo "[9] Global tools..."
    export PATH="$HOME/.bun/bin:$PATH"
    if command -v ctx7 >/dev/null 2>&1; then
        ok "ctx7 already installed"
    else
        bun install -g ctx7 2>/dev/null && ok "ctx7 installed" || fail "ctx7 failed"
    fi
    if command -v vastai >/dev/null 2>&1; then
        ok "vastai already installed"
    else
        uv tool install vastai 2>/dev/null && ok "vastai installed" || fail "vastai failed"
    fi
fi

# 10. Auto-commit timer
echo "[10] Auto-commit timer..."
PLIST_SRC="$DOTFILES_DIR/scripts/com.sasha.dotfiles.autocommit.plist"
PLIST_DST="$HOME/Library/LaunchAgents/com.sasha.dotfiles.autocommit.plist"
mkdir -p "$HOME/Library/LaunchAgents"
cp "$PLIST_SRC" "$PLIST_DST" 2>/dev/null
launchctl unload "$PLIST_DST" 2>/dev/null
launchctl load "$PLIST_DST" 2>/dev/null && ok "loaded" || fail "load failed"

# Summary
echo ""
if [ "$FAIL" -eq 0 ]; then
    echo "=== All steps succeeded ==="
else
    echo "=== Some steps failed — re-run to retry ==="
fi
echo ""
echo "Post-bootstrap manual steps:"
echo "1. Open 1Password -> Settings -> Developer -> enable SSH agent"
echo "2. Authorize your SSH signing key in 1Password"
if [ "$MACHINE_TYPE" = "laptop" ]; then
    echo "3. Open Raycast -> Import Snippets from ~/.config/raycast/exports/snippets.json"
    echo "4. Open Raycast -> Import Quicklinks from ~/.config/raycast/exports/quicklinks.json"
fi
