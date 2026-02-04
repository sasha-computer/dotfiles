#!/usr/bin/env bash
set -euo pipefail

# Fedora Package Installation Script
# Installs dnf packages and Flatpak apps, skipping already installed ones

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_skip() { echo -e "${YELLOW}→${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }
log_info() { echo -e "  $1"; }

# DNF packages to install
# Note: rust/cargo excluded - use rustup instead
DNF_PACKAGES=(
    # Shell/Terminal
    fish
    ghostty

    # Development
    nodejs
    gh
    awscli2

    # Utilities
    btop
    tmux
    jq
    fzf
    ripgrep
    unzip
    ImageMagick
)

# Binary commands to check (installed outside dnf)
# Format: "binary_name:description"
EXTERNAL_BINARIES=(
    "rustc:Rust (install via rustup.rs)"
    "cargo:Cargo (install via rustup.rs)"
    "agent:Cursor CLI (curl https://cursor.com/install -fsS | bash)"
)

# Nerd Fonts to install (from GitHub releases)
NERD_FONTS=(
    "JetBrainsMono"
)

# Flatpak apps (app-id)
FLATPAK_APPS=(
    "com.slack.Slack"
    "org.signal.Signal"
    "org.telegram.desktop"
    "md.obsidian.Obsidian"
    "com.spotify.Client"
    "org.videolan.VLC"
    "com.todoist.Todoist"
)

check_external_binaries() {
    echo "=== External Tools ==="
    for entry in "${EXTERNAL_BINARIES[@]}"; do
        local bin="${entry%%:*}"
        local desc="${entry#*:}"
        if command -v "$bin" &>/dev/null; then
            log_skip "Found: $bin"
        else
            log_error "Missing: $bin - $desc"
        fi
    done
    echo ""
}

install_dnf_packages() {
    echo "=== DNF Packages ==="
    local to_install=()

    for pkg in "${DNF_PACKAGES[@]}"; do
        if rpm -q "$pkg" &>/dev/null; then
            log_skip "Already installed: $pkg"
        else
            to_install+=("$pkg")
            log_info "Will install: $pkg"
        fi
    done

    if [[ ${#to_install[@]} -eq 0 ]]; then
        echo "All DNF packages already installed."
    else
        echo ""
        echo "Installing ${#to_install[@]} package(s)..."
        sudo dnf install -y "${to_install[@]}"
        log_success "Installed: ${to_install[*]}"
    fi
    echo ""
}

install_flatpak_apps() {
    echo "=== Flatpak Apps ==="

    # Ensure Flathub is added
    if ! flatpak remotes | grep -q flathub; then
        echo "Adding Flathub repository..."
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        log_success "Added Flathub repository"
    fi

    local to_install=()

    for app in "${FLATPAK_APPS[@]}"; do
        if flatpak list --app --columns=application | grep -q "^${app}$"; then
            log_skip "Already installed: $app"
        else
            to_install+=("$app")
            log_info "Will install: $app"
        fi
    done

    if [[ ${#to_install[@]} -eq 0 ]]; then
        echo "All Flatpak apps already installed."
    else
        echo ""
        echo "Installing ${#to_install[@]} Flatpak app(s)..."
        for app in "${to_install[@]}"; do
            flatpak install -y flathub "$app"
            log_success "Installed: $app"
        done
    fi
    echo ""
}

install_nerd_fonts() {
    echo "=== Nerd Fonts ==="
    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"

    for font in "${NERD_FONTS[@]}"; do
        if fc-list | grep -qi "${font}.*Nerd Font"; then
            log_skip "Already installed: $font Nerd Font"
        else
            log_info "Installing: $font Nerd Font"
            local url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.tar.xz"
            curl -fsSL "$url" | tar -xJ -C "$font_dir"
            log_success "Installed: $font Nerd Font"
        fi
    done

    fc-cache -f "$font_dir"
    echo ""
}

set_default_shell() {
    echo "=== Default Shell ==="
    local fish_path
    fish_path="$(which fish 2>/dev/null || true)"

    if [[ -z "$fish_path" ]]; then
        log_error "Fish not found. Install packages first."
        return 1
    fi

    if [[ "$SHELL" == "$fish_path" ]]; then
        log_skip "Fish is already the default shell"
    else
        echo "Setting fish as default shell..."
        if ! grep -q "$fish_path" /etc/shells; then
            echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
        fi
        chsh -s "$fish_path"
        log_success "Default shell changed to fish (re-login to apply)"
    fi
    echo ""
}

echo "=== Fedora Package Installation ==="
echo ""

check_external_binaries
install_dnf_packages
install_flatpak_apps
install_nerd_fonts
set_default_shell

echo "=== Installation Complete ==="
