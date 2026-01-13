# Global Claude Context

## Environment

- **Shell:** fish
- **OS:** NixOS (Framework 13 laptop)
- **Bash location:** `/run/current-system/sw/bin/bash`
- **Script shebangs:** Always use `#!/usr/bin/env bash` for portability

## Key Paths

- **Dotfiles:** `~/Dotfiles` (NixOS flake config)
- **Obsidian vault:** `~/Documents/2026/`
- **Ideas:** `~/Ideas/`
- **Projects:** `~/Developer/`

## Package Management

Use the `/nix` command for NixOS package management. Rebuild with `nrs`.

## Claude Settings

All Claude Code configuration is managed via NixOS dotfiles. **Never edit `~/.claude/` directly** - those files are deployed by Home Manager and will be overwritten.

- **Source location:** `~/Dotfiles/sources/claude/`
- **Deployed to:** `~/.claude/`
- **After changes:** Run `nrs` to rebuild and deploy

## Study Workflow

- `/study-session` - Start studying material from Obsidian vault
- `/drill` - Drill flashcards with hashcards
- Study materials: `~/Documents/2026/References/`
- Flashcards: `~/Documents/2026/Cards/`
