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
          xkb.layout = "us";
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
        { command = [ "1password" "--silent" ]; }
      ];

      binds = with config.lib.niri.actions; {
        "Mod+Return".action = spawn "ghostty";
        "Mod+D".action = spawn "fuzzel";
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
        "Mod+Down".action = focus-window-down;
        "Mod+Up".action = focus-window-up;
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
      };

      window-rules = [
        {
          matches = [{ app-id = "^firefox$"; }];
          default-column-width = { proportion = 0.6; };
        }
        {
          matches = [{ app-id = "^1password$"; }];
          open-floating = true;
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
    fuzzel
    wl-clipboard
    cliphist
    grim
    slurp
    swaybg
  ];
}
