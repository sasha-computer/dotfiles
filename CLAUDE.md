# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

NixOS dotfiles for a Framework 13 laptop running Plasma 6 desktop. Uses Home Manager for user configuration.

## Commands

Rebuild and switch to new configuration (run from this directory):

```sh
nrs
```

## Architecture

- `configuration.nix` - Main system config (boot, networking, desktop, audio, users, system packages)
- `home.nix` - Home Manager config, manages dotfiles via `home.file` and user programs (git, ssh)
- `firefox.nix` - Firefox policies, extensions, and privacy settings
- `hardware-configuration.nix` - Auto-generated hardware config (do not edit manually)
- `sources/` - Raw config files deployed to home directory by Home Manager
  - `scripts/` - Shell scripts deployed to `~/.local/bin`
  - Config files for fish, zed, ghostty, tridactyl, 1password

## Key Patterns

- User packages go in `users.users.sasha.packages` in `configuration.nix`
- Dotfiles are managed declaratively via `home.file` in `home.nix`
- SSH authentication uses 1Password agent
- Git commits are signed with SSH key via 1Password
