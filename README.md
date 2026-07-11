# dotfiles

Managed with [mise](https://mise.jdx.dev).

Heavily inspired by [jclem's dotfiles](https://github.com/jclem/dotfiles).

## Bootstrap a new Mac

```sh
curl -fsSL https://raw.githubusercontent.com/sasha-computer/dotfiles/main/bootstrap.sh | sh
```

This installs Homebrew, runs `brew bundle install` to install all formulae and casks from the Brewfile, then runs `mise bootstrap` which handles dotfiles, macOS defaults, shell, Fisher plugins, and LazyVim.

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

- `mise bootstrap --yes` — converge machine to declared state (runs `brew bundle install`, Fisher plugins, vastai)
- `mise dotfiles status` — check which dotfiles are missing/differ
- `brew bundle cleanup --file ~/src/github.com/sasha-computer/dotfiles/Brewfile` — remove brew packages not in Brewfile
- `dp` — stage, commit ("progress"), and push dotfile changes
