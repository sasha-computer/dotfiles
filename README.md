# dotfiles

Managed with [chezmoi](https://chezmoi.io).

## Managed files

- `~/.gitconfig`
- `~/.config/fish/config.fish`
- `~/.config/fish/functions/dp.fish`
- `~/.config/ghostty/config.ghostty`
- `~/.config/opencode/opencode.jsonc`
- `~/.config/opencode/tui.json`
- `~/.homebrew/Brewfile`
- Bootstrap script (Homebrew bundles, LazyVim, Fisher + plugins on first apply)

## Commands

- `chezmoi apply` — apply changes to home directory
- `chezmoi update` — pull latest from this repo and apply
- `chezmoi edit <file>` — edit a managed file in place
- `dp` — stage, commit ("progress"), and push all dotfile changes
