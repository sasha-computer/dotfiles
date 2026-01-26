# Linux-specific dotfile deployment
{ ... }:

{
  # ==========================================================================
  # Linux-specific Dotfiles
  # ==========================================================================

  home.file = {
    # 1Password SSH agent (Linux path)
    ".config/1Password/ssh/agent.toml".source = ../../sources/1password-ssh-agent.toml;
  };
}
