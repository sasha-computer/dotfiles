{
  pkgs,
  lib,
  ...
}:

{
  home-manager.backupFileExtension = "bak";

  home-manager.users.sasha = {

    # ========================================================================
    # Default Applications
    # ========================================================================

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };
    };

    # ========================================================================
    # Environment Variables
    # ========================================================================

    home.sessionVariables = {
      EDITOR = "nvim";
    };

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
      ".mozilla/native-messaging-hosts/tridactyl.json".source =
        "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";

      # Ghostty
      ".config/ghostty/config".source = ./sources/ghostty.conf;
    };

    # ========================================================================
    # Plasma (via plasma-manager)
    # ========================================================================

    programs.plasma = {
      enable = true;

      # Disable focus stealing prevention so Firefox pops up when opening links
      # from terminal (Plasma 6 / Wayland XDG activation token limitation)
      # Levels: 0=None, 1=Low, 2=Medium (default), 3=High, 4=Extreme
      configFile."kwinrc"."Windows"."FocusStealingPreventionLevel" = 0;

      hotkeys.commands = {
        "flameshot-clipboard" = {
          name = "Screenshot to clipboard";
          key = "Shift+Alt+4";
          command = "flameshot gui --clipboard";
        };
        "voxtype-toggle" = {
          name = "Voice-to-text toggle";
          key = "Meta+V";
          command = "voxtype record-toggle";
        };
      };

      # Klipper clipboard shortcuts - avoid conflict with Meta+V (voxtype)
      configFile."kglobalshortcutsrc"."plasmashell"."clipboard_action" = {
        value = "Meta+Shift+V,Meta+Ctrl+X,Clipboard History Popup";
      };
      configFile."kglobalshortcutsrc"."plasmashell"."show-on-mouse-pos" = {
        value = "none,Meta+V,Show Clipboard Items at Mouse Position";
      };
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
        push.autoSetupRemote = true;
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
