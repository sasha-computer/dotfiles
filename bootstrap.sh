#!/bin/sh
set -u

DOT="$HOME/dotfiles"
FAIL=0

ok()   { echo "  OK   $1"; }
fail() { echo "  FAIL $1"; FAIL=1; }

echo "[1] Homebrew"
if command -v brew >/dev/null 2>&1; then
    ok "already installed"
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && ok "installed" || fail "install failed"
fi
BREW=""
for p in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [ -x "$p" ] && BREW="$p" && break
done
[ -n "$BREW" ] && eval "$("$BREW" shellenv)"

echo "[2] Clone"
if [ -d "$DOT/.git" ]; then
    ok "already cloned"
else
    git clone https://github.com/sasha-computer/dotfiles.git "$DOT" && ok "cloned" || fail "clone failed"
fi

echo "[3] Packages"
if [ -f "$DOT/Brewfile" ]; then
    brew bundle install --file "$DOT/Brewfile" && ok "installed" || fail "some failed — re-run: brew bundle install --file ~/dotfiles/Brewfile"
else
    fail "Brewfile not found"
fi

echo "[4] macOS defaults"
sh "$DOT/scripts/macos-defaults.sh" && ok "applied" || fail "failed"

echo "[5] Symlinks"
rm -rf "$HOME/.config/fish"
sh "$DOT/scripts/symlink.sh" && ok "linked" || fail "failed"

echo "[6] Fisher"
FISH_PATH=""
for p in /opt/homebrew/bin/fish /usr/local/bin/fish; do
    [ -x "$p" ] && FISH_PATH="$p" && break
done
if [ -z "$FISH_PATH" ]; then
    fail "fish not installed"
else
    fish "$DOT/scripts/bootstrap-fish.fish" && ok "installed" || fail "fisher install failed"
fi

echo "[7] Login shell"
if [ -n "$FISH_PATH" ]; then
    CURRENT=$(dscl . -read "$HOME" UserShell 2>/dev/null | awk '{print $2}')
    if [ "$CURRENT" = "$FISH_PATH" ]; then
        ok "already fish"
    else
        grep -qx "$FISH_PATH" /etc/shells 2>/dev/null || echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
        chsh -s "$FISH_PATH" && ok "set to fish" || fail "chsh failed"
    fi
fi

echo "[8] LazyVim"
if [ -d "$HOME/.config/nvim" ]; then
    ok "already installed"
else
    git clone https://github.com/LazyVim/starter "$HOME/.config/nvim" \
        && rm -rf "$HOME/.config/nvim/.git" \
        && ok "installed" || fail "clone failed"
fi

echo "[9] Global tools"
export PATH="$HOME/.bun/bin:$PATH"
command -v ctx7 >/dev/null 2>&1 && ok "ctx7 already installed" || { bun install -g ctx7 2>/dev/null && ok "ctx7 installed" || fail "ctx7 failed"; }
command -v vastai >/dev/null 2>&1 && ok "vastai already installed" || { uv tool install vastai 2>/dev/null && ok "vastai installed" || fail "vastai failed"; }

echo "[10] Verify"
BROKEN=0
check() {
    if [ -L "$1" ] && [ -e "$1" ]; then
        ok "$1"
    elif [ -L "$1" ]; then
        fail "$1 (broken symlink)"
        BROKEN=1
    else
        fail "$1 (missing)"
        BROKEN=1
    fi
}
check "$HOME/.gitconfig"
check "$HOME/.ssh/config"
check "$HOME/.config/ghostty"
check "$HOME/.config/zed"
check "$HOME/.agents/skills"
check "$HOME/.config/fish/config.fish"
check "$HOME/.config/fish/fish_plugins"
check "$HOME/.config/fish/functions/dp.fish"

if [ -n "$FISH_PATH" ]; then
    fish -c "type -q fisher" 2>/dev/null && ok "fisher" || fail "fisher not installed"
    fish -c "fisher list" 2>/dev/null | grep -q "jorgebucaran/fisher" && ok "fisher plugins" || fail "fisher plugins missing"
fi

CURRENT_SHELL=$(dscl . -read "$HOME" UserShell 2>/dev/null | awk '{print $2}')
[ "$CURRENT_SHELL" = "$FISH_PATH" ] && ok "login shell is fish" || fail "login shell is $CURRENT_SHELL (should be $FISH_PATH)"

echo ""
if [ "$FAIL" -eq 0 ]; then
    echo "=== ALL GOOD ==="
else
    echo "=== SOME STEPS FAILED — re-run to retry ==="
fi
echo ""
echo "Manual step: Open 1Password -> Settings -> Developer -> enable SSH agent + authorize signing key"
