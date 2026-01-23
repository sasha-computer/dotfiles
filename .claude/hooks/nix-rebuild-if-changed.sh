#!/usr/bin/env bash
# Rebuild if any file was modified

cd ~/Dotfiles || exit 0

if [ -n "$(git status --porcelain)" ]; then
  sudo nixos-rebuild switch --flake ~/Dotfiles#fw13
fi
