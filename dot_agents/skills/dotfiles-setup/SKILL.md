---
name: dotfiles-setup
description: Explains how dotfiles are managed on this machine. Use when adding, modifying, or troubleshooting system packages, Brewfile entries, chezmoi configuration, fish shell setup, opencode config, or any managed dotfile. Also use when a user asks how the machine is configured or how to install a new tool.
---

# Dotfiles Setup

All machine configuration lives in a single Git repository at `~/dotfiles`, managed via [chezmoi](https://www.chezmoi.io) and [Homebrew](https://brew.sh). The repo is public on GitHub at `sasha-computer/dotfiles`.

## Repository layout

```
~/dotfiles/
  bootstrap.sh                        # One-shot installer for a fresh Mac
  reset.sh                            # Reverts everything bootstrap.sh does
  Brewfile.laptop                     # Homebrew packages for laptop
  Brewfile.nas                        # Homebrew packages for NAS
  .chezmoiignore                      # Excludes non-config files from chezmoi
  scripts/
    macos-defaults.sh                 # All defaults write commands
    bootstrap-fish.fish               # Fisher plugin installation
  dot_gitconfig                       # ~/.gitconfig (SSH signing via 1Password)
  private_dot_ssh/private_config      # ~/.ssh/config (0600 perms, 1Password SSH agent)
  dot_config/
    fish/                             # Shell config, plugins, functions
    ghostty/                          # Terminal config
    zed/                              # Editor config
    opencode/                         # opencode.jsonc, instructions, TUI theme
    raycast/                          # AppleScripts + JSON exports
    netnewswire/                      # OPML feed list
  dot_agents/
    skills/                           # opencode skills (this file, others)
```

## How chezmoi manages dotfiles

chezmoi reads the source directory (`~/dotfiles`, configured in `~/.config/chezmoi/chezmoi.toml`) and writes config files to the home directory. Files with `dot_` prefix get a leading dot in the target. `private_` prefix sets 0600 permissions.

To apply changes after editing source files:
```sh
chezmoi apply
```

To see what would change without applying:
```sh
chezmoi diff
```

The `dp` fish function runs `chezmoi apply` before committing, so the workflow is: edit files in `~/dotfiles/`, run `dp`.

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
3. Run `dp` to commit.

To remove packages not listed in a Brewfile:
```sh
brew bundle cleanup --file ~/dotfiles/Brewfile.laptop --force
```

### Global tools

- `ctx7` installed via `bun install -g ctx7` (binary in `~/.bun/bin/`, added to PATH in `config.fish`)
- `vastai` installed via `uv tool install vastai`

## Fish shell

- Config: `dot_config/fish/config.fish` — sets environment variables, PATH, and interactive aliases.
- Plugins: `dot_config/fish/fish_plugins` — list of Fisher plugins, installed by `scripts/bootstrap-fish.fish`.
- Functions: `dot_config/fish/functions/` — one function per file (e.g., `dp.fish`, `nnw-export.fish`).
- Login shell is set to `/opt/homebrew/bin/fish` by `bootstrap.sh`.

When writing fish functions, follow the `write-fish-functions` skill.

## opencode configuration

Managed in `dot_config/opencode/`:
- `opencode.jsonc` — main config (schema, instructions, permissions).
- `anti-llmisms-short.md` — writing style rules, loaded as an instruction.
- `pr-conventions.md` — PR description rules, loaded as an instruction.
- `caveman-mode.md` — caveman mode instruction.
- `tui.json` — TUI theme.

Skills live in `dot_agents/skills/` and are written to `~/.agents/skills/` by chezmoi. Both opencode and Zed auto-load skills from `~/.agents/skills/<name>/SKILL.md`. Zed live-reloads on file changes; opencode requires a restart after config changes.

### Creating new skills

Create the folder and `SKILL.md` under `~/dotfiles/dot_agents/skills/<skill-name>/`. Run `chezmoi apply` (or `dp`) to sync to `~/.agents/skills/`.

When creating or modifying opencode config, follow the `customize-opencode` skill. After any config change, restart opencode.

## Raycast

- AppleScripts in `dot_config/raycast/` (toggle dock, toggle menu bar) — managed by chezmoi, placed at `~/.config/raycast/`.
- Snippets and Quicklinks exported as JSON to `dot_config/raycast/exports/` — diff-friendly, version-controlled.
- To export: run "Export Snippets" and "Export Quicklinks" in Raycast, save to `~/.config/raycast/exports/`.
- To import on a new machine: run "Import Snippets" and "Import Quicklinks" in Raycast, select the JSON files.

## NetNewsWire

- OPML feed list at `dot_config/netnewswire/Subscriptions.opml` — placed at `~/.config/netnewswire/` by chezmoi.
- To export: run `nnw-export` fish function (copies from NNW data dir to dotfiles repo).
- To import on a new machine: `bootstrap.sh` copies the OPML to `~/Library/Application Support/NetNewsWire/Accounts/OnMyMac/Subscriptions.opml`. NNW reads it on next launch.

## Git configuration

- SSH commit signing via 1Password (`dot_gitconfig`).
- SSH agent socket configured in `private_dot_ssh/private_config`.
- Post-bootstrap manual step: enable SSH agent in 1Password settings and authorize the signing key.

## Committing changes

Use the `dp` fish function to apply, stage, commit, and push:

```sh
fish -c dp
```

This runs `chezmoi apply`, commits with message "progress", and pushes. For area-prefixed commit messages, follow the `dotfiles-git-commit` skill.

## Bootstrap a new Mac

```sh
curl -fsSL https://bootstrap.sasha.computer | sh -s -- laptop
# or
curl -fsSL https://bootstrap.sasha.computer | sh -s -- nas
```

This installs Homebrew, clones the repo to `~/dotfiles`, installs chezmoi, applies config files, installs packages from the appropriate Brewfile, sets macOS defaults, changes login shell to fish, clones LazyVim, and installs Fisher plugins.

## Reset a Mac

```sh
curl -fsSL https://reset.sasha.computer | sh -s -- laptop
```

Reverts everything bootstrap.sh did: removes chezmoi-managed files, uninstalls brew packages, resets macOS defaults, resets login shell to zsh, removes LazyVim/Fisher/tools, optionally uninstalls Homebrew, removes the dotfiles repo.
