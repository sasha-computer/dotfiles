---
name: nix-dotfiles
description: Activates when making changes to Claude Code settings (settings.json, CLAUDE.md, commands, skills, context). All Claude configuration is managed via NixOS dotfiles in ~/Dotfiles/ and deployed by Home Manager. Never edit ~/.claude/ directly.
---

# NixOS Dotfiles Skill

All Claude Code configuration files are managed declaratively via NixOS and Home Manager. Direct edits to `~/.claude/` will be overwritten on rebuild.

## Source of Truth

All Claude configuration lives in:
```
~/Dotfiles/sources/claude/
├── CLAUDE.md           # Global context
├── settings.json       # Claude Code settings (statusline, etc.)
├── commands/           # Slash commands
├── skills/             # Skills like this one
└── context/            # Shared context files
```

These are deployed to `~/.claude/` by Home Manager via `home.nix`.

## Workflow for Changes

When the user asks to modify Claude settings:

1. **Edit the source file** in `~/Dotfiles/sources/claude/`
2. **Never edit** files directly in `~/.claude/`
3. **Remind the user** to run `nrs` to apply changes

## Examples

### Modifying settings.json
```bash
# Edit the source
~/Dotfiles/sources/claude/settings.json

# NOT this (will be overwritten)
~/.claude/settings.json
```

### Adding a new command
```bash
# Create in sources
~/Dotfiles/sources/claude/commands/my-command.md

# Then rebuild
nrs
```

### Adding a new skill
1. Create directory: `~/Dotfiles/sources/claude/skills/skill-name/`
2. Add `SKILL.md` with frontmatter (name, description)
3. Run `nrs` to deploy

## After Making Changes

Always remind the user:
```
Run `nrs` to rebuild and deploy the configuration.
```

## Key Files

| File | Purpose |
|------|---------|
| `~/Dotfiles/home.nix` | Home Manager config that deploys Claude files |
| `~/Dotfiles/sources/claude/` | Source directory for all Claude config |
| `~/.claude/` | Deployed location (read-only, managed by Nix) |
