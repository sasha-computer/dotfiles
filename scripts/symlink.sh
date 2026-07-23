#!/bin/sh
DOT="$HOME/dotfiles"

link() {
    src="$1"
    dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        mv "$dst" "$dst.bak.$(date +%s)"
        echo "  BACKUP: $dst"
    fi
    ln -s "$src" "$dst"
}

link "$DOT/.gitconfig"        "$HOME/.gitconfig"
link "$DOT/.gitignore_global" "$HOME/.gitignore_global"
link "$DOT/.ssh/config"       "$HOME/.ssh/config"
chmod 600 "$DOT/.ssh/config" 2>/dev/null || true

for dir in ghostty zed; do
    link "$DOT/.config/$dir" "$HOME/.config/$dir"
done
link "$DOT/.agents/skills" "$HOME/.agents/skills"

link "$DOT/.config/fish/config.fish"  "$HOME/.config/fish/config.fish"
link "$DOT/.config/fish/fish_plugins" "$HOME/.config/fish/fish_plugins"
for f in "$DOT"/.config/fish/functions/*.fish; do
    [ -f "$f" ] && link "$f" "$HOME/.config/fish/functions/$(basename "$f")"
done
