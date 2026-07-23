#!/bin/sh
# Auto-commit and push dotfiles. Called by launchd hourly.
cd "$HOME/dotfiles" || exit 0
git add -A
if ! git diff --cached --quiet 2>/dev/null; then
    git commit -m "auto" 2>/dev/null && git push 2>/dev/null
fi
