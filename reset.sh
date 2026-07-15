#!/bin/sh
set -eu

MACHINE_TYPE="${1:-}"
if [ -z "$MACHINE_TYPE" ]; then
    printf "Machine type (laptop/nas): "
    read MACHINE_TYPE < /dev/tty
fi

DOTFILES_DIR="$HOME/dotfiles"

# --- 1. Remove chezmoi-managed config files ---
if command -v chezmoi >/dev/null 2>&1; then
    chezmoi remove --all --force 2>/dev/null || true
fi

# --- 2. Uninstall brew packages ---
BREW_BIN=""
for p in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [ -x "$p" ] && BREW_BIN="$p" && break
done

if [ -n "$BREW_BIN" ] && [ -f "$DOTFILES_DIR/Brewfile.$MACHINE_TYPE" ]; then
    eval "$("$BREW_BIN" shellenv)"
    brew bundle cleanup --file "$DOTFILES_DIR/Brewfile.$MACHINE_TYPE" --force 2>/dev/null || true
fi

# --- 3. Reset macOS defaults ---
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

# --- 4. Reset login shell ---
chsh -s /bin/zsh 2>/dev/null || true

# --- 5. Remove LazyVim ---
rm -rf "$HOME/.config/nvim" 2>/dev/null || true

# --- 6. Remove Fisher + fish config ---
if command -v fish >/dev/null 2>&1; then
    fish -c "fisher remove -a" 2>/dev/null || true
fi
rm -rf "$HOME/.config/fish" 2>/dev/null || true

# --- 7. Remove global tools ---
bun remove -g ctx7 2>/dev/null || true
uv tool uninstall vastai 2>/dev/null || true

# --- 8. Remove NNW OPML ---
rm -f "$HOME/Library/Application Support/NetNewsWire/Accounts/OnMyMac/Subscriptions.opml" 2>/dev/null || true

# --- 9. Remove chezmoi ---
brew uninstall chezmoi 2>/dev/null || true
rm -rf "$HOME/.config/chezmoi" 2>/dev/null || true

# --- 10. Optional: uninstall Homebrew ---
printf "Uninstall Homebrew? (y/N): "
read UNINSTALL_BREW < /dev/tty
if [ "$UNINSTALL_BREW" = "y" ] || [ "$UNINSTALL_BREW" = "Y" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
fi

# --- 11. Remove dotfiles repo ---
rm -rf "$DOTFILES_DIR" 2>/dev/null || true

echo ""
echo "=== Reset complete. Restart your Mac. ==="
