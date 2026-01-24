#!/usr/bin/env bash
# Rebuild if any file was modified

cd ~/Dotfiles || exit 0

if [ -n "$(git status --porcelain)" ]; then
  if sudo nixos-rebuild switch --flake ~/Dotfiles#fw13; then
    git add -A
    git commit -m "nixos: auto-commit after successful rebuild"
    git push
  fi
fi
