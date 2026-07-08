# dotfiles

Managed with [chezmoi](https://chezmoi.io).

## Managed files

- `~/.gitconfig`
- `~/.config/fish/config.fish`
- `~/.config/fish/functions/dp.fish`
- `~/.config/fish/functions/dp-auto.fish`
- `~/.config/ghostty/config.ghostty`
- `~/.config/zed/settings.json`
- `~/.config/opencode/opencode.jsonc`
- `~/.config/opencode/tui.json`
- `~/.homebrew/Brewfile`
- `~/Library/LaunchAgents/com.neo.dotfiles.plist`
- Bootstrap script (Homebrew bundles, LazyVim, Fisher + plugins on first apply)
- Daily auto-backup via launchd (runs dp-auto at 12:00)

## Commands

- `chezmoi apply` — apply changes to home directory
- `chezmoi update` — pull latest from this repo and apply
- `chezmoi edit <file>` — edit a managed file in place
- `dp` — stage, commit ("progress"), and push all dotfile changes
- `dp-auto` — silent version for launchd (no colors)
