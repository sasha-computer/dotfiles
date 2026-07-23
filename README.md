# dotfiles

Symlink-based dotfile management with Homebrew. Edits to `~/dotfiles/` are live immediately via symlinks.

## Bootstrap a new Mac

```sh
curl -fsSL https://bootstrap.sasha.computer | sh
```

Each step is independent and re-runnable. If a step fails, just re-run the whole script — completed steps are skipped. The script verifies all symlinks and Fisher at the end.

## Reset a Mac

```sh
curl -fsSL https://reset.sasha.computer | sh
```

## Post-bootstrap (manual)

1. Open 1Password -> Settings -> Developer -> enable SSH agent
2. Authorize your SSH signing key in 1Password

## How it works

- `scripts/symlink.sh` creates symlinks from `~/dotfiles/` into `$HOME`
- Symlinks run BEFORE Fisher so `fish_plugins` exists when fisher reads it
- Fish files are symlinked individually (Fisher generates files we don't track)
- Everything else is symlinked at the directory level

## Symlinked files

- `~/.gitconfig`
- `~/.gitignore_global`
- `~/.ssh/config` (0600)
- `~/.config/fish/` (config.fish, fish_plugins, functions/*.fish — individual files)
- `~/.config/ghostty/config.ghostty`
- `~/.config/zed/` (settings.json, keymap.json)
- `~/.agents/skills/` (7 skills)
- `~/.config/nvim/` (LazyVim, cloned by bootstrap — not symlinked)

## Commands

- `dp` — stage, commit, and push
- `brew bundle install --file ~/dotfiles/Brewfile` — install packages
- `brew bundle cleanup --file ~/dotfiles/Brewfile --force` — remove unlisted packages
- `sh ~/dotfiles/scripts/symlink.sh` — re-create symlinks (run after adding new files)
- `sh ~/dotfiles/scripts/macos-defaults.sh` — re-apply macOS defaults

## Adding a new package

```sh
brew install foo
# Add "brew \"foo\"" to ~/dotfiles/Brewfile
```

## Adding a new config file

1. Create the file in `~/dotfiles/` at the appropriate path
2. Run `sh ~/dotfiles/scripts/symlink.sh`
3. Done
