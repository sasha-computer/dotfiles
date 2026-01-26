# Common dotfile deployment (cross-platform)
{ ... }:

{
  # ==========================================================================
  # Dotfiles (shared across platforms)
  # ==========================================================================

  home.file = {
    # Ghostty terminal
    ".config/ghostty/config".source = ../../sources/ghostty.conf;

    # Claude Code
    ".claude/CLAUDE.md".source = ../../sources/claude/CLAUDE.md;
    ".claude/settings.json".source = ../../sources/claude/settings.json;
    ".claude/commands" = {
      source = ../../sources/claude/commands;
      recursive = true;
    };
    ".claude/skills" = {
      source = ../../sources/claude/skills;
      recursive = true;
    };
    ".claude/context" = {
      source = ../../sources/claude/context;
      recursive = true;
    };
  };
}
