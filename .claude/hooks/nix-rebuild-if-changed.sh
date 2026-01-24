#!/usr/bin/env bash
# Rebuild if any file was modified, commit with AI-generated message

cd ~/Dotfiles || exit 0

if [ -n "$(git status --porcelain)" ]; then
  if sudo nixos-rebuild switch --flake ~/Dotfiles#fw13; then
    git add -A

    # Generate commit message using Claude
    diff_output=$(git diff --cached)
    commit_msg=$(echo "$diff_output" | claude -p "Generate a concise git commit message for these NixOS dotfiles changes. Output ONLY the commit message, no explanation. Use conventional commit style (e.g., 'feat:', 'fix:', 'chore:'). Keep it under 72 characters.")

    # Fallback if claude fails
    if [ -z "$commit_msg" ]; then
      commit_msg="nixos: auto-commit after successful rebuild"
    fi

    git commit -m "$commit_msg"
    git push
  fi
fi
