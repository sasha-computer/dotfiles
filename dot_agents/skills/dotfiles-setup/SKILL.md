---
name: dotfiles-setup
description: Explains how dotfiles are managed on this machine. Use when adding, modifying, or troubleshooting system packages, Brewfile entries, mise configuration, fish shell setup, opencode config, or any managed dotfile. Also use when a user asks how the machine is configured or how to install a new tool.
---

# Dotfiles Setup

All machine configuration lives in a single Git repository at `~/src/github.com/sasha-computer/dotfiles`, managed via [mise](https://mise.jdx.dev) and [Homebrew](https://brew.sh). The repo is public on GitHub at `sasha-computer/dotfiles`.

## Repository layout

```
dotfiles/
  bootstrap.sh         # One-shot installer for a fresh Mac
  Brewfile             # Homebrew formulae and casks
  mise.toml            # mise settings, dotfiles map, macOS defaults, bootstrap tasks
  README.md            # Human-facing docs
  scripts/bootstrap.fish  # Fisher plugin installation
  dot_gitconfig        # ~/.gitconfig (SSH signing via 1Password)
  dot_ssh/config       # ~/.ssh/config (1Password SSH agent)
  dot_config/
    fish/              # Shell config, plugins, functions
    ghostty/           # Terminal config
    zed/               # Editor config
    opencode/          # opencode.jsonc, instructions, TUI theme
  dot_agents/
    skills/            # opencode skills (this file, others)
```

## How mise manages dotfiles

mise's dotfiles feature symlinks files from the repo into the home directory. The mapping lives in `mise.toml` under `[dotfiles]`:

- `~/.dotfiles` symlinks to the repo directory itself.
- Individual files like `~/.gitconfig` and `~/.ssh/config` are symlinked directly.
- Directories like `~/.config/fish/`, `~/.config/opencode/`, and `~/.agents/skills/` use `mode = "symlink-each"` which symlinks each child file individually (so repo additions appear without re-running bootstrap).
- `~/.config/mise/config.toml` symlinks to the repo's `mise.toml`, making mise self-managing.

After editing any managed file, run `mise dotfiles status` to verify symlinks are correct, or `mise bootstrap --yes --force-dotfiles` to repair them.

## How packages are installed

### Homebrew (Brewfile)

All Homebrew packages are declared in `Brewfile`. Formulae use `brew "name"` and casks use `cask "name"`.

To add a new tool:
1. Add a line to `Brewfile` in alphabetical order within its section.
2. Run `brew bundle install --file ~/src/github.com/sasha-computer/dotfiles/Brewfile`.

To remove packages not listed in the Brewfile:
```sh
brew bundle cleanup --file ~/src/github.com/sasha-computer/dotfiles/Brewfile
```

### mise tools

mise can also manage language runtimes via `[tools]` in `mise.toml`. Currently `rust = "stable"` is declared. Add other runtimes here if needed (e.g., `node = "22"`, `python = "3.12"`).

### Bootstrap tasks

`mise.toml` defines `[tasks.bootstrap]` which runs after tools are installed:
1. `brew bundle install` from the Brewfile
2. `scripts/bootstrap.fish` (installs Fisher and fish plugins)
3. `uv tool install vastai`

## Fish shell

- Config: `dot_config/fish/config.fish` — sets environment variables, mise activation, and interactive aliases.
- Plugins: `dot_config/fish/fish_plugins` — list of Fisher plugins, installed by `scripts/bootstrap.fish`.
- Functions: `dot_config/fish/functions/` — one function per file (e.g., `dp.fish`).
- Login shell is set to `/opt/homebrew/bin/fish` via `[bootstrap.user]` in `mise.toml`.

When writing fish functions, follow the `write-fish-functions` skill.

## opencode configuration

Managed in `dot_config/opencode/`:
- `opencode.jsonc` — main config (schema, instructions, permissions).
- `anti-llmisms-short.md` — writing style rules, loaded as an instruction.
- `pr-conventions.md` — PR description rules, loaded as an instruction.
- `tui.json` — TUI theme.

Skills live in `dot_agents/skills/` and are symlinked to `~/.agents/skills/` via mise. Both opencode and Zed auto-load skills from `~/.agents/skills/<name>/SKILL.md`. Zed live-reloads on file changes; opencode requires a restart after config changes.

### Creating new skills

**Always create skills in the dotfiles repo**, never directly in `~/.agents/skills/`. Skills placed directly in `~/.agents/skills/` won't be symlinked from the repo and won't survive a fresh bootstrap.

To create a new skill:
1. Create the folder and `SKILL.md` under `~/src/github.com/sasha-computer/dotfiles/dot_agents/skills/<skill-name>/`.
2. Run `mise dotfiles status` to verify the symlink appears, or `mise bootstrap --yes --force-dotfiles` to link it.
3. The skill is immediately available to both opencode and Zed.

When creating or modifying opencode config, follow the `customize-opencode` skill. After any config change, restart opencode.

## Git configuration

- SSH commit signing via 1Password (`dot_gitconfig`).
- SSH agent socket configured in `dot_ssh/config`.
- Post-bootstrap manual step: enable SSH agent in 1Password settings and authorize the signing key.

## Committing changes

Use the `dp` fish function to stage, commit, and push:

```sh
fish -c dp
```

This commits with message "progress" and pushes. For area-prefixed commit messages, follow the `dotfiles-git-commit` skill. Run `dp` after verifying everything works.

## Bootstrap a new Mac

```sh
curl -fsSL https://raw.githubusercontent.com/sasha-computer/dotfiles/main/bootstrap.sh | sh
```

This installs Homebrew, runs `brew bundle install`, then `mise bootstrap --yes --force-dotfiles` (dotfiles, macOS defaults, hooks, tasks).
