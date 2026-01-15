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

      # Zed
      ".config/zed/settings.json".source = ./sources/zed-settings.json;
      ".config/zed/keymap.json".source = ./sources/zed-keymap.json;

      # Tridactyl
      ".config/tridactyl/tridactylrc".source = ./sources/tridactylrc;
      ".mozilla/native-messaging-hosts/tridactyl.json".source =
        "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";

      # Ghostty
      ".config/ghostty/config".source = ./sources/ghostty.conf;

      # Claude Code
      ".claude/CLAUDE.md".source = ./sources/claude/CLAUDE.md;
      ".claude/settings.json".source = ./sources/claude/settings.json;
      ".claude/commands" = {
        source = ./sources/claude/commands;
        recursive = true;
      };
      ".claude/skills" = {
        source = ./sources/claude/skills;
        recursive = true;
      };
      ".claude/context" = {
        source = ./sources/claude/context;
        recursive = true;
      };

      # Autostart 1Password on login (for SSH agent)
      ".config/autostart/1password.desktop".text = ''
        [Desktop Entry]
        Name=1Password
        Exec=1password --silent
        Terminal=false
        Type=Application
        StartupNotify=false
        X-GNOME-Autostart-enabled=true
      '';
    };

    # ========================================================================
    # Plasma (via plasma-manager)
    # ========================================================================

    programs.plasma = {
      enable = true;

      # Start with empty session (don't restore windows from last session)
      configFile."ksmserverrc"."General"."loginMode" = "emptySession";

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
          command = "voxtype record toggle";
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

    programs.fish = {
      enable = true;
      plugins = [
        {
          name = "z";
          src = pkgs.fishPlugins.z.src;
        }
      ];
      interactiveShellInit = builtins.readFile ./sources/config.fish;
    };

    # ========================================================================
    # Services
    # ========================================================================

    services.syncthing = {
      enable = true;
      package = pkgs.unstable.syncthing;
    };

    # ========================================================================
    # Version
    # ========================================================================

    home.stateVersion = "25.11";
  };
}
