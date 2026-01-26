# Linux-specific shell configuration
{
  pkgs,
  lib,
  ...
}:

{
  # ==========================================================================
  # Git (Linux-specific: op-ssh-sign path)
  # ==========================================================================

  programs.git.settings = {
    "gpg \"ssh\"".program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
  };

  # ==========================================================================
  # SSH (Linux 1Password socket path)
  # ==========================================================================

  programs.ssh.matchBlocks = {
    "*" = {
      extraOptions = {
        IdentityAgent = "~/.1password/agent.sock";
      };
    };
  };

  # ==========================================================================
  # Fish (Linux-specific aliases and init)
  # ==========================================================================

  programs.fish = {
    shellAliases = {
      # NixOS rebuild
      nrs = "sudo nixos-rebuild switch --flake ~/Dotfiles#fw13";
      cfg = "cd ~/Dotfiles/ && cc";
    };
    interactiveShellInit = builtins.readFile ../../../sources/config.fish;
  };
}
