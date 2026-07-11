#!/bin/sh
set -eu

REPO_DIR="$HOME/src/github.com/sasha-computer/dotfiles"

# Clone if not already present
if [ ! -d "$REPO_DIR" ]; then
  mkdir -p "$(dirname "$REPO_DIR")"
  git clone https://github.com/sasha-computer/dotfiles.git "$REPO_DIR"
fi

cd "$REPO_DIR"

# Homebrew
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install all packages (formulae + casks) including mise
brew bundle install --file "$REPO_DIR/Brewfile"

# Trust and bootstrap (dotfiles, defaults, hooks, tasks)
mise trust
mise bootstrap --yes --force-dotfiles
