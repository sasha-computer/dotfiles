#!/bin/sh
set -eu

# --- 1. Machine type ---
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

# --- 2. Homebrew ---
BREW_BIN=""
for p in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [ -x "$p" ] && BREW_BIN="$p" && break
done

if [ -z "$BREW_BIN" ]; then
    printf "Installing Homebrew...\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    for p in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        [ -x "$p" ] && BREW_BIN="$p" && break
    done
fi

eval "$("$BREW_BIN" shellenv)"

# --- 3. Clone dotfiles ---
if [ ! -d "$DOTFILES_DIR" ]; then
    git clone https://github.com/sasha-computer/dotfiles.git "$DOTFILES_DIR"
fi

# --- 4. Install chezmoi ---
brew install chezmoi

# --- 5. Configure chezmoi source dir ---
mkdir -p "$HOME/.config/chezmoi"
cat > "$HOME/.config/chezmoi/chezmoi.toml" <<EOF
sourceDir = "$DOTFILES_DIR"
EOF

# --- 6. Apply config files ---
chezmoi apply --force

# --- 7. Install packages ---
brew bundle install --file "$DOTFILES_DIR/Brewfile.$MACHINE_TYPE" || {
    echo "WARNING: Some packages failed to install."
    echo "Re-run: brew bundle install --file ~/dotfiles/Brewfile.$MACHINE_TYPE"
}

# --- 8. macOS defaults ---
sh "$DOTFILES_DIR/scripts/macos-defaults.sh"

# --- 9. Set login shell ---
if [ -x /opt/homebrew/bin/fish ]; then
    chsh -s /opt/homebrew/bin/fish
else
    echo "WARNING: fish not installed, skipping shell change."
fi

# --- 10. LazyVim ---
test -d "$HOME/.config/nvim" || (git clone https://github.com/LazyVim/starter "$HOME/.config/nvim" && rm -rf "$HOME/.config/nvim/.git")

# --- 11. Fisher ---
if command -v fish >/dev/null 2>&1; then
    fish "$DOTFILES_DIR/scripts/bootstrap-fish.fish"
fi

# --- 12. Laptop extras ---
if [ "$MACHINE_TYPE" = "laptop" ]; then
    bun install -g ctx7 2>/dev/null || echo "WARNING: ctx7 install failed."
    uv tool install vastai 2>/dev/null || echo "WARNING: vastai install failed."

    echo ""
    echo "=== Raycast manual import ==="
    echo "1. Open Raycast"
    echo "2. Run 'Import Snippets' -> select ~/.config/raycast/exports/snippets.json"
    echo "3. Run 'Import Quicklinks' -> select ~/.config/raycast/exports/quicklinks.json"
fi

echo ""
echo "=== Bootstrap complete ==="
echo "Post-bootstrap manual steps:"
echo "1. Open 1Password -> Settings -> Developer -> enable SSH agent"
echo "2. Authorize your SSH signing key in 1Password"
