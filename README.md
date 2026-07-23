# dotfiles

Symlink-based dotfile management with Homebrew. No chezmoi, no apply step — edits to `~/dotfiles/` are live immediately via symlinks. An auto-commit timer pushes changes hourly.

## Bootstrap a new Mac

```sh
curl -fsSL https://raw.githubusercontent.com/sasha-computer/dotfiles/main/bootstrap.sh -o /tmp/bootstrap.sh && sh /tmp/bootstrap.sh
```

Each step is independent and re-runnable. If a step fails, just re-run the whole script — completed steps are skipped. The script verifies all symlinks and Fisher at the end.

## Reset a Mac

```sh
curl -fsSL https://raw.githubusercontent.com/sasha-computer/dotfiles/main/reset.sh -o /tmp/reset.sh && sh /tmp/reset.sh
```

## Post-bootstrap (manual)

1. Open 1Password -> Settings -> Developer -> enable SSH agent
2. Authorize your SSH signing key in 1Password

## How it works

- `scripts/symlink.sh` creates symlinks from `~/dotfiles/` into `$HOME`
- Symlinks run BEFORE Fisher so `fish_plugins` exists when fisher reads it
- Fish files are symlinked individually (Fisher generates files we don't track)
- Everything else is symlinked at the directory level
- `scripts/autocommit.sh` runs hourly via launchd, commits and pushes any changes

## Symlinked files

- `~/.gitconfig`
- `~/.gitignore_global`
- `~/.ssh/config` (0600)
- `~/.config/fish/` (config.fish, fish_plugins, functions/*.fish — individual files)
- `~/.config/ghostty/config.ghostty`
- `~/.config/zed/` (settings.json, keymap.json)
- `~/.config/opencode/` (opencode.jsonc, tui.json, instructions)
- `~/.agents/skills/` (8 skills)
- `~/.config/nvim/` (LazyVim, cloned by bootstrap — not symlinked)

## Commands

- `dp` — stage, commit, and push (manual fallback to auto-commit)
- `brew bundle install --file ~/dotfiles/Brewfile` — install packages
- `brew bundle cleanup --file ~/dotfiles/Brewfile --force` — remove unlisted packages
- `sh ~/dotfiles/scripts/symlink.sh` — re-create symlinks (run after adding new files)
- `sh ~/dotfiles/scripts/macos-defaults.sh` — re-apply macOS defaults

## Adding a new package

```sh
brew install foo
# Add "brew \"foo\"" to ~/dotfiles/Brewfile
```

The auto-commit timer will handle committing and pushing.

## Adding a new config file

1. Create the file in `~/dotfiles/` at the appropriate path
2. Run `sh ~/dotfiles/scripts/symlink.sh`
3. Done — auto-commit handles the rest
