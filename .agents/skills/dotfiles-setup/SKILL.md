---
name: dotfiles-setup
description: Explains how dotfiles are managed on this machine. Use when adding, modifying, or troubleshooting system packages, Brewfile entries, symlink setup, fish shell setup, or any managed dotfile. Also use when a user asks how the machine is configured or how to install a new tool.
---

# Dotfiles Setup

All machine configuration lives in a single Git repository at `~/dotfiles`, managed via symlinks and [Homebrew](https://brew.sh). The repo is public on GitHub at `sasha-computer/dotfiles`.

## Repository layout

```
~/dotfiles/
  bootstrap.sh                        # One-shot installer for a fresh Mac
  reset.sh                            # Reverts everything bootstrap.sh does
  Brewfile                            # Homebrew packages
  .gitconfig                          # ~/.gitconfig (SSH signing via 1Password)
  .gitignore_global                   # ~/.gitignore_global
  .ssh/config                         # ~/.ssh/config (0600 perms, 1Password SSH agent)
  .config/
    fish/                             # Shell config, plugins, functions
    ghostty/                          # Terminal config
    zed/                              # Editor config
  .agents/
    skills/                           # Skills (this file, others)
  scripts/
    symlink.sh                        # Creates symlinks from ~/dotfiles into $HOME
    macos-defaults.sh                 # All defaults write commands
    bootstrap-fish.fish               # Fisher plugin installation
```

## How symlinks manage dotfiles

`scripts/symlink.sh` creates symlinks from `~/dotfiles/` into `$HOME`. The repo mirrors the home directory structure. Fish files are symlinked individually (Fisher generates files we don't track); everything else is symlinked at the directory level.

Edits to files in `~/dotfiles/` are live immediately — no apply step needed.

To re-create symlinks (e.g., after adding a new file):
```sh
sh ~/dotfiles/scripts/symlink.sh
```

The `dp` fish function stages, commits, and pushes changes manually.

## How packages are installed

### Homebrew (Brewfile)

A single `Brewfile` lists all packages. The bootstrap script installs from it.

To install packages on a new machine or after changing the Brewfile:
```sh
brew bundle install --file ~/dotfiles/Brewfile
```

To add a new tool:
1. `brew install foo`
2. Add `brew "foo"` to `~/dotfiles/Brewfile`.
3. Run `dp` to commit.

To remove packages not listed in the Brewfile:
```sh
brew bundle cleanup --file ~/dotfiles/Brewfile --force
```

### Global tools

- `ctx7` installed via `bun install -g ctx7` (binary in `~/.bun/bin/`, added to PATH in `config.fish`)
- `vastai` installed via `uv tool install vastai`

## Fish shell

- Config: `.config/fish/config.fish` — sets environment variables, PATH, and interactive aliases.
- Plugins: `.config/fish/fish_plugins` — list of Fisher plugins, installed by `scripts/bootstrap-fish.fish`.
- Functions: `.config/fish/functions/` — one function per file (e.g., `dp.fish`).
- Login shell is set to `/opt/homebrew/bin/fish` by `bootstrap.sh`.

When writing fish functions, follow the `write-fish-functions` skill.

## Skills

Skills live in `.agents/skills/` and are symlinked to `~/.agents/skills/`. Zed auto-loads skills from `~/.agents/skills/<name>/SKILL.md` and live-reloads on file changes.

### Creating new skills

Create the folder and `SKILL.md` under `~/dotfiles/.agents/skills/<skill-name>/`. Run `sh ~/dotfiles/scripts/symlink.sh` to create the symlink.

## Git configuration

- SSH commit signing via 1Password (`.gitconfig`).
- SSH agent socket configured in `.ssh/config`.
- Post-bootstrap manual step: enable SSH agent in 1Password settings and authorize the signing key.

## Committing changes

Use the `dp` fish function to stage, commit, and push:

```sh
fish -c dp
```

For area-prefixed commit messages, follow the `dotfiles-git-commit` skill.

## Bootstrap a new Mac

```sh
curl -fsSL https://bootstrap.sasha.computer | sh
```

Each step is independent and re-runnable. If a step fails, re-run the whole script — completed steps are skipped. The script verifies all symlinks and Fisher at the end.

This installs Homebrew, clones the repo, installs packages, sets macOS defaults, creates symlinks, installs Fisher, sets login shell to fish, clones LazyVim, installs global tools, and verifies everything.

## Reset a Mac

```sh
curl -fsSL https://reset.sasha.computer | sh
```

Reverts everything bootstrap.sh did: removes symlinks, uninstalls brew packages, resets macOS defaults, resets login shell to zsh, removes LazyVim/Fisher/tools, optionally uninstalls Homebrew, removes the dotfiles repo.
