# dotfiles

Managed with [mise](https://mise.jdx.dev).

## Bootstrap a new Mac

```sh
curl -fsSL https://raw.githubusercontent.com/sasha-computer/dotfiles/main/bootstrap.sh | sh
```

This installs Homebrew, mise, clones the repo, and runs `mise bootstrap` which handles packages, dotfiles, macOS defaults, shell, Fisher plugins, and LazyVim.

## Post-bootstrap (manual)

1. Open 1Password → Settings → Developer → enable SSH agent
2. Authorize your SSH signing key in 1Password

## Managed files

- `~/.gitconfig`
- `~/.ssh/config`
- `~/.config/fish/` (config.fish, fish_plugins, functions/dp.fish)
- `~/.config/ghostty/config.ghostty`
- `~/.config/zed/settings.json`
- `~/.config/opencode/` (opencode.jsonc, tui.json, anti-llmisms-short.md, pr-conventions.md)
- `~/.config/nvim/` (LazyVim, cloned by bootstrap hook)

## Commands

- `mise bootstrap --yes` — converge machine to declared state
- `mise dotfiles status` — check which dotfiles are missing/differ
- `mise bootstrap status --missing` — check everything that's out of sync
- `dp` — stage, commit ("progress"), and push dotfile changes
