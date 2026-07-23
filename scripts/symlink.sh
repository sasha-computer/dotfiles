#!/bin/sh
# Create symlinks from ~/dotfiles into $HOME.
# Re-runnable: replaces existing symlinks, skips real files with a warning.

DOTFILES="$HOME/dotfiles"

link() {
    src="$1"
    dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        echo "SKIP: $dst exists (not a symlink)"
        return 0
    fi
    ln -s "$src" "$dst"
    echo "LINK: $dst -> $src"
}

# Single files
link "$DOTFILES/.gitconfig"       "$HOME/.gitconfig"
link "$DOTFILES/.gitignore_global" "$HOME/.gitignore_global"
link "$DOTFILES/.ssh/config"       "$HOME/.ssh/config"
chmod 600 "$DOTFILES/.ssh/config" 2>/dev/null || true

# Whole directories
for dir in ghostty zed opencode raycast; do
    link "$DOTFILES/.config/$dir" "$HOME/.config/$dir"
done
link "$DOTFILES/.agents/skills" "$HOME/.agents/skills"

# Fish: individual files (Fisher generates files we don't want in the repo)
link "$DOTFILES/.config/fish/config.fish"   "$HOME/.config/fish/config.fish"
link "$DOTFILES/.config/fish/fish_plugins"  "$HOME/.config/fish/fish_plugins"
for f in "$DOTFILES"/.config/fish/functions/*.fish; do
    [ -f "$f" ] && link "$f" "$HOME/.config/fish/functions/$(basename "$f")"
done
