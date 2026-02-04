#!/usr/bin/env bash
set -euo pipefail

# Fedora Dotfiles Setup Script
# Creates symlinks from this repo to appropriate config locations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCES_DIR="$SCRIPT_DIR/sources"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_skip() { echo -e "${YELLOW}→${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }

# Create symlink with backup
# Args: source_path dest_path
create_link() {
    local src="$1"
    local dest="$2"
    local dest_dir
    dest_dir="$(dirname "$dest")"

    # Create destination directory if needed
    if [[ ! -d "$dest_dir" ]]; then
        mkdir -p "$dest_dir"
        log_success "Created directory: $dest_dir"
    fi

    # Check if source exists
    if [[ ! -e "$src" ]]; then
        log_error "Source not found: $src"
        return 1
    fi

    # Handle existing destination
    if [[ -L "$dest" ]]; then
        local current_target
        current_target="$(readlink "$dest")"
        if [[ "$current_target" == "$src" ]]; then
            log_skip "Already linked: $dest"
            return 0
        fi
        rm "$dest"
    elif [[ -e "$dest" ]]; then
        mv "$dest" "$dest.bak"
        log_success "Backed up: $dest → $dest.bak"
    fi

    ln -s "$src" "$dest"
    log_success "Linked: $dest → $src"
}

# Link a directory recursively (for claude commands/skills/context)
# Args: source_dir dest_dir
link_directory() {
    local src_dir="$1"
    local dest_dir="$2"

    if [[ ! -d "$src_dir" ]]; then
        log_skip "Source directory not found: $src_dir"
        return 0
    fi

    mkdir -p "$dest_dir"

    find "$src_dir" -type f | while read -r src_file; do
        local rel_path="${src_file#$src_dir/}"
        local dest_file="$dest_dir/$rel_path"
        create_link "$src_file" "$dest_file"
    done
}

echo "=== Fedora Dotfiles Setup ==="
echo "Source: $SOURCES_DIR"
echo ""

# Fish shell
create_link "$SOURCES_DIR/config.fish" "$HOME/.config/fish/config.fish"

# Ghostty terminal
create_link "$SOURCES_DIR/ghostty.conf" "$HOME/.config/ghostty/config"

# Zed editor
create_link "$SOURCES_DIR/zed-settings.json" "$HOME/.config/zed/settings.json"
create_link "$SOURCES_DIR/zed-keymap.json" "$HOME/.config/zed/keymap.json"

# 1Password SSH agent
create_link "$SOURCES_DIR/1password-ssh-agent.toml" "$HOME/.config/1Password/ssh/agent.toml"

# Git config
create_link "$SOURCES_DIR/gitconfig" "$HOME/.gitconfig"

# Claude Code
create_link "$SOURCES_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
create_link "$SOURCES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
link_directory "$SOURCES_DIR/claude/commands" "$HOME/.claude/commands"
link_directory "$SOURCES_DIR/claude/skills" "$HOME/.claude/skills"
link_directory "$SOURCES_DIR/claude/context" "$HOME/.claude/context"

echo ""
echo "=== Setup Complete ==="
