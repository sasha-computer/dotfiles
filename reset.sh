#!/bin/sh
set -eu

DOTFILES_DIR="$HOME/dotfiles"

remove_link() {
    if [ -L "$1" ]; then
        rm "$1"
        echo "Removed: $1"
    fi
}

remove_link "$HOME/.gitconfig"
remove_link "$HOME/.gitignore_global"
remove_link "$HOME/.ssh/config"
for dir in ghostty zed; do
    remove_link "$HOME/.config/$dir"
done
remove_link "$HOME/.agents/skills"
for f in config.fish fish_plugins; do
    remove_link "$HOME/.config/fish/$f"
done
for f in "$DOTFILES_DIR"/.config/fish/functions/*.fish; do
    [ -f "$f" ] && remove_link "$HOME/.config/fish/functions/$(basename "$f")"
done

BREW_BIN=""
for p in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [ -x "$p" ] && BREW_BIN="$p" && break
done
if [ -n "$BREW_BIN" ] && [ -f "$DOTFILES_DIR/Brewfile" ]; then
    eval "$("$BREW_BIN" shellenv)"
    brew bundle cleanup --file "$DOTFILES_DIR/Brewfile" --force 2>/dev/null || true
fi

defaults delete com.apple.dock autohide 2>/dev/null || true
defaults delete com.apple.dock show-recents 2>/dev/null || true
defaults delete com.apple.finder AppleShowAllFiles 2>/dev/null || true
defaults delete com.apple.finder ShowPathbar 2>/dev/null || true
defaults delete com.apple.finder ShowStatusBar 2>/dev/null || true
defaults delete com.apple.finder FXPreferredViewStyle 2>/dev/null || true
defaults delete com.apple.finder FXEnableExtensionChangeWarning 2>/dev/null || true
defaults delete com.apple.finder FXDefaultSearchScope 2>/dev/null || true
defaults delete com.apple.finder WarnOnEmptyTrash 2>/dev/null || true
defaults delete com.apple.finder FXRemoveOldTrashItems 2>/dev/null || true
defaults delete NSGlobalDomain KeyRepeat 2>/dev/null || true
defaults delete NSGlobalDomain InitialKeyRepeat 2>/dev/null || true
defaults delete NSGlobalDomain ApplePressAndHoldEnabled 2>/dev/null || true
defaults delete com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking 2>/dev/null || true
defaults delete NSGlobalDomain NSAutomaticCapitalizationEnabled 2>/dev/null || true
defaults delete NSGlobalDomain NSAutomaticDashSubstitutionEnabled 2>/dev/null || true
defaults delete NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled 2>/dev/null || true
defaults delete NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled 2>/dev/null || true
defaults delete NSGlobalDomain NSAutomaticSpellingCorrectionEnabled 2>/dev/null || true
defaults delete com.apple.menuextra.battery ShowPercent 2>/dev/null || true
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true

chsh -s /bin/zsh 2>/dev/null || true

rm -rf "$HOME/.config/nvim" 2>/dev/null || true

if command -v fish >/dev/null 2>&1; then
    fish -c "fisher remove -a" 2>/dev/null || true
fi
rm -rf "$HOME/.config/fish" 2>/dev/null || true

bun remove -g ctx7 2>/dev/null || true
uv tool uninstall vastai 2>/dev/null || true

printf "Uninstall Homebrew? (y/N): "
read UNINSTALL_BREW < /dev/tty
if [ "$UNINSTALL_BREW" = "y" ] || [ "$UNINSTALL_BREW" = "Y" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
fi

rm -rf "$DOTFILES_DIR" 2>/dev/null || true

echo ""
echo "=== Reset complete. Restart your Mac. ==="
