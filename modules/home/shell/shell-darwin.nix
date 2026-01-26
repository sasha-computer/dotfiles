# macOS-specific shell configuration
{
  pkgs,
  lib,
  ...
}:

{
  # ==========================================================================
  # Git (macOS-specific: op-ssh-sign path)
  # ==========================================================================

  programs.git.settings = {
    "gpg \"ssh\"".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
  };

  # ==========================================================================
  # SSH (macOS 1Password socket path)
  # ==========================================================================

  programs.ssh.matchBlocks = {
    "*" = {
      extraOptions = {
        IdentityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
      };
    };
  };

  # ==========================================================================
  # Fish (macOS-specific aliases and init)
  # ==========================================================================

  programs.fish = {
    shellAliases = {
      # Darwin rebuild (nrs alias for muscle memory from NixOS)
      drs = "sudo darwin-rebuild switch --flake ~/dotfiles#m1-max";
      nrs = "sudo darwin-rebuild switch --flake ~/dotfiles#m1-max";
      cfg = "cd ~/dotfiles/ && cc";
    };
    interactiveShellInit = ''
      # Fish shell configuration (macOS)
      # Aliases are managed declaratively in shell modules

      fish_add_path ~/.local/bin

      set fish_greeting
      set -gx SSH_AUTH_SOCK ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

      # ==========================================================================
      # Functions (can't be declared via shellAliases)
      # ==========================================================================

      function get-ralph
          if test -z "$argv[1]"
              echo "Usage: get-ralph <project-name>"
              return 1
          end
          gh repo create $argv[1] -p neutronmoderator/ralph-wiggum --private --clone
      end
    '';
  };
}
