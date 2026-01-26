# macOS-specific dotfile deployment
{ ... }:

{
  # ==========================================================================
  # macOS-specific Dotfiles
  # ==========================================================================

  home.file = {
    # 1Password SSH agent (macOS uses same path as Linux)
    ".config/1Password/ssh/agent.toml".source = ../../sources/1password-ssh-agent.toml;
  };
}
