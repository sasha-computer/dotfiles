{ pkgs, lib, config, ... }:

let
  focus-or-spawn = pkgs.writeShellScriptBin "focus-or-spawn" ''
    APP_ID="$1"
    shift
    COMMAND=("$@")
    WINDOW_ID=$(niri msg --json windows | ${pkgs.jq}/bin/jq -r ".[] | select(.app_id == \"$APP_ID\") | .id" | head -1)
    if [ -n "$WINDOW_ID" ]; then
      niri msg action focus-window --id "$WINDOW_ID"
    else
      "''${COMMAND[@]}" &
    fi
  '';
in {
  programs.niri = {
    enable = true;
    package = pkgs.niri-stable;

    settings = {
      input = {
        mod-key = "Alt";
        mod-key-nested = "Super";
        keyboard = {
          xkb = {
            layout = "us";
            options = "caps:escape";
          };
          repeat-delay = 300;
          repeat-rate = 50;
        };
        touchpad = {
          tap = true;
          natural-scroll = true;
          dwt = true;
        };
        mouse.natural-scroll = false;
      };

      outputs = {
        "DP-4" = {
          scale = 1.5;
          mode = {
            width = 3840;
            height = 2160;
            refresh = 120.0;
          };
        };
        "eDP-1" = {
          scale = 1.7;
          mode = {
            width = 2880;
            height = 1920;
            refresh = 120.0;
          };
        };
      };

      layout = {
        gaps = 8;
        border.enable = false;
        focus-ring = {
          enable = true;
          width = 3;
          active.color = "#7aa2f7";
          inactive.color = "transparent";
        };
        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
        ];
        default-column-width = { proportion = 1.0 / 2.0; };
      };

      spawn-at-startup = [
        { command = [ "xwayland-satellite" ]; }
      ];

      binds = with config.lib.niri.actions; {
        "Mod+Return".action = spawn "ghostty";
        "Mod+Space".action = spawn "fuzzel";
        "Mod+W".action = spawn "${focus-or-spawn}/bin/focus-or-spawn" "firefox" "firefox";
        "Mod+S".action = spawn "${focus-or-spawn}/bin/focus-or-spawn" "Slack" "slack";
        "Mod+E".action = spawn "${focus-or-spawn}/bin/focus-or-spawn" "com.mitchellh.ghostty" "ghostty";

        "Mod+Q".action = close-window;
        "Mod+Grave".action = focus-window-previous;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+Tab".action = toggle-overview;

        "Mod+H".action = focus-column-left;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+L".action = focus-column-right;
        "Mod+Left".action = focus-column-left;
        "Mod+Down".action = focus-workspace-down;
        "Mod+Up".action = focus-workspace-up;
        "Mod+Right".action = focus-column-right;

        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+J".action = move-window-down;
        "Mod+Shift+K".action = move-window-up;
        "Mod+Shift+L".action = move-column-right;

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;

        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;

        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";
        "Mod+R".action = switch-preset-column-width;
        "Mod+C".action = center-column;

        "Mod+Shift+E".action = quit;
        "Mod+Shift+P".action = spawn "systemctl" "poweroff";
        "Mod+Escape".action = spawn "swaylock" "-f";  # Lock screen
        "Mod+Shift+T".action = spawn "dms" "ipc" "call" "theme" "toggle";  # Toggle dark/light

        # Screenshot selection to clipboard (macOS-style)
        "Alt+Shift+4".action = spawn "sh" "-c" "grim -g \"$(slurp)\" - | wl-copy";

        # Disable laptop display (when TV is connected)
        "Mod+Shift+M".action = spawn "niri" "msg" "output" "eDP-1" "off";
        # Re-enable laptop display
        "Mod+Shift+N".action = spawn "niri" "msg" "output" "eDP-1" "on";

        # Ctrl + vertical scroll: switch workspaces
        "Ctrl+WheelScrollDown".action = focus-workspace-down;
        "Ctrl+WheelScrollUp".action = focus-workspace-up;

        # Ctrl + horizontal scroll: focus windows left/right
        "Ctrl+WheelScrollLeft".action = focus-column-left;
        "Ctrl+WheelScrollRight".action = focus-column-right;

        # Framework 13 function keys
        # Audio (F1-F3)
        "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
        "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
        "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" "5%+";

        # Mic mute (F4)
        "XF86AudioMicMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";

        # Brightness (F7-F8)
        "XF86MonBrightnessDown".action = spawn "brightnessctl" "set" "5%-";
        "XF86MonBrightnessUp".action = spawn "brightnessctl" "set" "5%+";

        # Media controls
        "XF86AudioPlay".action = spawn "playerctl" "play-pause";
        "XF86AudioPrev".action = spawn "playerctl" "previous";
        "XF86AudioNext".action = spawn "playerctl" "next";
      };

      window-rules = [
        {
          # All windows open maximized by default
          open-maximized = true;
        }
        {
          matches = [{ app-id = "^firefox$"; }];
          default-column-width = { proportion = 0.6; };
        }
        {
          matches = [{ app-id = "^1password$"; }];
          open-floating = true;
        }
        {
          matches = [{ app-id = "^Slack$"; }];
          open-on-workspace = "3";
        }
        {
          matches = [{ app-id = "^org\\.telegram\\.desktop$"; }];
          open-on-workspace = "3";
        }
      ];

      animations = {
        slowdown = 1.0;
        window-open.kind.spring = {
          damping-ratio = 0.8;
          stiffness = 500;
          epsilon = 0.0001;
        };
      };
    };
  };

  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = false;
      restartIfChanged = true;
    };
    enableSystemMonitoring = true;
    enableVPN = false;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = false;
    enableClipboardPaste = true;

    niri = {
      enableKeybinds = false;  # We define our own keybinds above
      enableSpawn = true;
      includes.enable = false;
    };
  };

  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    grim
    slurp
    swaybg
    swaylock
    brightnessctl
    playerctl
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "monospace:size=16";
        width = 50;
        lines = 15;
        horizontal-pad = 20;
        vertical-pad = 15;
        inner-pad = 10;
      };
    };
  };

  # USB auto-mount daemon
  services.udiskie = {
    enable = true;
    tray = "auto";  # Show tray icon when devices present
    notify = true;  # Desktop notifications on mount/unmount
    settings.program_options.file_manager = "dolphin";
  };

  # GTK/icon theme (needed for tray icons like udiskie)
  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  # Gnome keyring for secret storage (replaces kwallet for Signal, etc.)
  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };

  # Notification daemon for Wayland
  services.mako = {
    enable = true;
    settings.default-timeout = 5000;
  };

  # Signal: use gnome-keyring instead of kwallet (overrides system .desktop file)
  xdg.desktopEntries.signal-desktop = {
    name = "Signal";
    exec = "signal-desktop --password-store=\"gnome-libsecret\" %U";
    icon = "signal-desktop";
    type = "Application";
    categories = [ "Network" "InstantMessaging" ];
    startupNotify = true;
    settings.StartupWMClass = "Signal";
  };

  # Hide the original Signal desktop entry from the package
  xdg.desktopEntries.Signal = {
    name = "Signal (unused)";
    exec = "signal-desktop";
    noDisplay = true;
  };

  # Auto dark mode: switch to dark at 5pm, light at 7am
  systemd.user.services.dms-dark-mode = {
    Unit.Description = "Switch DMS to dark mode";
    Service = {
      Type = "oneshot";
      ExecStart = "dms ipc call theme dark";
    };
  };

  systemd.user.timers.dms-dark-mode = {
    Unit.Description = "Switch to dark mode at 5pm";
    Timer = {
      OnCalendar = "*-*-* 17:00:00";
      Persistent = true;  # Run if missed (e.g., laptop was asleep)
    };
    Install.WantedBy = [ "timers.target" ];
  };

  systemd.user.services.dms-light-mode = {
    Unit.Description = "Switch DMS to light mode";
    Service = {
      Type = "oneshot";
      ExecStart = "dms ipc call theme light";
    };
  };

  systemd.user.timers.dms-light-mode = {
    Unit.Description = "Switch to light mode at 7am";
    Timer = {
      OnCalendar = "*-*-* 07:00:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  # Lock screen before suspend (user service has access to Wayland session)
  systemd.user.services.lock-before-sleep = {
    Unit = {
      Description = "Lock screen before suspend";
      Before = [ "sleep.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.swaylock}/bin/swaylock -f";
    };
    Install = {
      WantedBy = [ "sleep.target" ];
    };
  };
}
