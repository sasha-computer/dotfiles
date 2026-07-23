---
name: dotfiles-setup
description: Explains how dotfiles are managed on this machine. Use when adding, modifying, or troubleshooting system packages, Brewfile entries, symlink setup, fish shell setup, opencode config, or any managed dotfile. Also use when a user asks how the machine is configured or how to install a new tool.
---

# Dotfiles Setup

All machine configuration lives in a single Git repository at `~/dotfiles`, managed via symlinks and [Homebrew](https://brew.sh). The repo is public on GitHub at `sasha-computer/dotfiles`.

## Repository layout

```
~/dotfiles/
  bootstrap.sh                        # One-shot installer for a fresh Mac
  reset.sh                            # Reverts everything bootstrap.sh does
  Brewfile.laptop                     # Homebrew packages for laptop
  Brewfile.nas                        # Homebrew packages for NAS
  .gitconfig                          # ~/.gitconfig (SSH signing via 1Password)
  .gitignore_global                   # ~/.gitignore_global
  .ssh/config                         # ~/.ssh/config (0600 perms, 1Password SSH agent)
  .config/
    fish/                             # Shell config, plugins, functions
    ghostty/                          # Terminal config
    zed/                              # Editor config
    opencode/                         # opencode.jsonc, instructions, TUI theme
    raycast/                          # AppleScripts + JSON exports
  .agents/
    skills/                           # opencode skills (this file, others)
  scripts/
    symlink.sh                        # Creates symlinks from ~/dotfiles into $HOME
    macos-defaults.sh                 # All defaults write commands
    bootstrap-fish.fish               # Fisher plugin installation
    autocommit.sh                     # Hourly git commit+push (called by launchd)
    com.sasha.dotfiles.autocommit.plist  # launchd plist for auto-commit
```

## How symlinks manage dotfiles

`scripts/symlink.sh` creates symlinks from `~/dotfiles/` into `$HOME`. The repo mirrors the home directory structure. Fish files are symlinked individually (Fisher generates files we don't track); everything else is symlinked at the directory level.

Edits to files in `~/dotfiles/` are live immediately — no apply step needed.

To re-create symlinks (e.g., after adding a new file):
```sh
sh ~/dotfiles/scripts/symlink.sh
```

An auto-commit timer (launchd) runs hourly, committing and pushing any changes. The `dp` fish function is a manual fallback.

## How packages are installed

### Homebrew (Brewfile.$machine_type)

Two Brewfiles exist: `Brewfile.laptop` (full package set) and `Brewfile.nas` (minimal CLI tools). The bootstrap script installs from the appropriate file based on machine type.

To install packages on a new machine or after changing a Brewfile:
```sh
brew bundle install --file ~/dotfiles/Brewfile.laptop
```

To add a new tool:
1. `brew install foo`
2. Add `brew "foo"` to the appropriate Brewfile in `~/dotfiles/`.
3. The auto-commit timer will handle committing and pushing.

To remove packages not listed in a Brewfile:
```sh
brew bundle cleanup --file ~/dotfiles/Brewfile.laptop --force
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

## opencode configuration

Managed in `.config/opencode/`:
- `opencode.jsonc` — main config (schema, instructions, permissions).
- `anti-llmisms-short.md` — writing style rules, loaded as an instruction.
- `pr-conventions.md` — PR description rules, loaded as an instruction.
- `caveman-mode.md` — caveman mode instruction.
- `tui.json` — TUI theme.

Skills live in `.agents/skills/` and are symlinked to `~/.agents/skills/`. Both opencode and Zed auto-load skills from `~/.agents/skills/<name>/SKILL.md`. Zed live-reloads on file changes; opencode requires a restart after config changes.

### Creating new skills

Create the folder and `SKILL.md` under `~/dotfiles/.agents/skills/<skill-name>/`. Run `sh ~/dotfiles/scripts/symlink.sh` to create the symlink.

When creating or modifying opencode config, follow the `customize-opencode` skill. After any config change, restart opencode.

## Raycast

- AppleScripts in `.config/raycast/` (toggle dock, toggle menu bar) — symlinked to `~/.config/raycast/`.
- Snippets and Quicklinks exported as JSON to `.config/raycast/exports/` — diff-friendly, version-controlled.
- To export: run "Export Snippets" and "Export Quicklinks" in Raycast, save to `~/.config/raycast/exports/`.
- To import on a new machine: run "Import Snippets" and "Import Quicklinks" in Raycast, select the JSON files.

## Git configuration

- SSH commit signing via 1Password (`.gitconfig`).
- SSH agent socket configured in `.ssh/config`.
- Post-bootstrap manual step: enable SSH agent in 1Password settings and authorize the signing key.

## Committing changes

The auto-commit timer (launchd) runs hourly, committing and pushing any changes automatically. The `dp` fish function is a manual fallback:

```sh
fish -c dp
```

This stages, commits with message "progress", and pushes. For area-prefixed commit messages, follow the `dotfiles-git-commit` skill.

## Bootstrap a new Mac

```sh
curl -fsSL https://bootstrap.sasha.computer | sh -s -- laptop
# or
curl -fsSL https://bootstrap.sasha.computer | sh -s -- nas
```

Each step is independent and re-runnable. If a step fails, re-run the whole script — completed steps are skipped.

This installs Homebrew, clones the repo to `~/dotfiles`, creates symlinks, installs packages from the appropriate Brewfile, sets macOS defaults, changes login shell to fish, clones LazyVim, installs Fisher plugins, installs global tools (laptop only), and sets up the auto-commit timer.

## Reset a Mac

```sh
curl -fsSL https://reset.sasha.computer | sh -s -- laptop
```

Reverts everything bootstrap.sh did: removes symlinks, uninstalls brew packages, resets macOS defaults, resets login shell to zsh, removes LazyVim/Fisher/tools, unloads auto-commit timer, optionally uninstalls Homebrew, removes the dotfiles repo.
