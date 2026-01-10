{
  pkgs,
  lib,
  ...
}:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.backupFileExtension = "bak";

  home-manager.users.sasha = {

    # ========================================================================
    # Dotfiles
    # ========================================================================

    home.file = {
      # Scripts
      ".local/bin" = {
        source = ./sources/scripts;
        recursive = true;
      };

      # 1Password
      ".config/1Password/ssh/agent.toml".source = ./sources/1password-ssh-agent.toml;

      # Fish
      ".config/fish/config.fish".source = ./sources/config.fish;

      # Zed
      ".config/zed/settings.json".source = ./sources/zed-settings.json;
      ".config/zed/keymap.json".source = ./sources/zed-keymap.json;

      # Tridactyl
      ".config/tridactyl/tridactylrc".source = ./sources/tridactylrc;

      # Ghostty
      ".config/ghostty/config".source = ./sources/ghostty.conf;
    };

    # ========================================================================
    # Programs
    # ========================================================================

    programs.git = {
      enable = true;
      settings = {
        user.name = "nmod";
        user.email = "33594434+neutronmoderator@users.noreply.github.com";
        gpg.format = "ssh";
        "gpg \"ssh\"" = {
          program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
        };
        commit.gpgsign = true;
        user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGug35ClTdXh9ege0MmldlDu+xu+EKILrtlqkSbpBhPX";
      };
    };

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

    # ========================================================================
    # Version
    # ========================================================================

    home.stateVersion = "25.11";
  };
}
