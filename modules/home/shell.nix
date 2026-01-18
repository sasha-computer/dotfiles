{
  pkgs,
  lib,
  ...
}:

{
  # ==========================================================================
  # Git (using new settings syntax)
  # ==========================================================================

  programs.git = {
    enable = true;
    signing = {
      signByDefault = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGug35ClTdXh9ege0MmldlDu+xu+EKILrtlqkSbpBhPX";
    };
    settings = {
      user.name = "nmod";
      user.email = "33594434+neutronmoderator@users.noreply.github.com";
      gpg.format = "ssh";
      "gpg \"ssh\"".program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      push.autoSetupRemote = true;
    };
  };

  # ==========================================================================
  # SSH
  # ==========================================================================

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        extraOptions = {
          IdentityAgent = "~/.1password/agent.sock";
        };
      };
    };
  };

  # ==========================================================================
  # Fish
  # ==========================================================================

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
    ];
    interactiveShellInit = builtins.readFile ../../sources/config.fish;
  };
}
