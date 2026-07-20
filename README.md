# dotfiles

Managed with [chezmoi](https://www.chezmoi.io) and [Homebrew](https://brew.sh).

## Bootstrap a new Mac

```sh
curl -fsSL https://bootstrap.sasha.computer | sh -s -- laptop
# or
curl -fsSL https://bootstrap.sasha.computer | sh -s -- nas
```

This installs Homebrew, clones the repo to `~/dotfiles`, installs chezmoi, applies config files, installs packages, sets macOS defaults, changes login shell to fish, clones LazyVim, and installs Fisher plugins.

## Reset a Mac

```sh
curl -fsSL https://reset.sasha.computer | sh -s -- laptop
```

Reverts everything bootstrap.sh did.

## Post-bootstrap (manual)

1. Open 1Password -> Settings -> Developer -> enable SSH agent
2. Authorize your SSH signing key in 1Password
3. If laptop: open Raycast, run "Import Snippets" and "Import Quicklinks" from `~/.config/raycast/exports/`

## Managed files

- `~/.gitconfig`
- `~/.ssh/config` (0600)
- `~/.config/fish/` (config.fish, fish_plugins, functions/dp.fish)
- `~/.config/ghostty/config.ghostty`
- `~/.config/zed/` (settings.json, keymap.json)
- `~/.config/opencode/` (opencode.jsonc, tui.json, instructions)
- `~/.config/raycast/` (AppleScripts, exports)
- `~/.agents/skills/` (7 skills)
- `~/.config/nvim/` (LazyVim, cloned by bootstrap)

## Commands

- `chezmoi apply` — sync source files to home directory
- `chezmoi diff` — show what would change
- `dp` — apply, stage, commit ("progress"), and push
- `brew bundle install --file ~/dotfiles/Brewfile.laptop` — install packages
- `brew bundle cleanup --file ~/dotfiles/Brewfile.laptop --force` — remove unlisted packages
- `sh ~/dotfiles/scripts/macos-defaults.sh` — re-apply macOS defaults

## Adding a new package

```sh
brew install foo
# Add "brew \"foo\"" to ~/dotfiles/Brewfile.laptop
dp
```
