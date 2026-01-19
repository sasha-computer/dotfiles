{ pkgs, lib, ... }:

{
  # ==========================================================================
  # Niri Configuration (via niri-flake)
  # ==========================================================================

  programs.niri = {
    enable = true;
    package = pkgs.niri-stable;

    settings = {
      # ------------------------------------------------------------------
      # Input Configuration
      # ------------------------------------------------------------------
      input = {
        keyboard = {
          xkb.layout = "us";
          repeat-delay = 300;
          repeat-rate = 50;
        };
        touchpad = {
          tap = true;
          natural-scroll = true;
          dwt = true; # disable while typing
        };
        mouse = {
          natural-scroll = false;
        };
      };

      # ------------------------------------------------------------------
      # Output Configuration (Framework 13 display)
      # ------------------------------------------------------------------
      outputs."eDP-1" = {
        scale = 1.5; # Adjust for your preference
      };

      # ------------------------------------------------------------------
      # Layout Settings
      # ------------------------------------------------------------------
      layout = {
        gaps = 8;
        border = {
          width = 2;
          active.color = "#7aa2f7"; # Tokyo Night blue
          inactive.color = "#565f89";
        };
        focus-ring = {
          enable = false; # DMS handles focus indication
        };
        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
        ];
        default-column-width = { proportion = 1.0 / 2.0; };
      };

      # ------------------------------------------------------------------
      # Spawn at Startup
      # ------------------------------------------------------------------
      spawn-at-startup = [
        # XWayland for legacy X11 apps
        { command = [ "${pkgs.xwayland-satellite}/bin/xwayland-satellite" ]; }
      ];

      # ------------------------------------------------------------------
      # Key Bindings
      # ------------------------------------------------------------------
      binds = {
        # Terminal
        "Mod+Return".action.spawn = [ "warp-terminal" ];
        "Mod+T".action.spawn = [ "ghostty" ];

        # Application Launcher
        "Mod+D".action.spawn = [ "fuzzel" ];

        # Screenshots (flameshot)
        "Shift+Alt+4".action.spawn = [ "flameshot" "gui" "--clipboard" ];

        # Voxtype toggle
        "Mod+V".action.spawn = [ "voxtype" "record" "toggle" ];

        # Window Management
        "Mod+Q".action = "close-window";
        "Mod+F".action = "maximize-column";
        "Mod+Shift+F".action = "fullscreen-window";

        # Focus Movement
        "Mod+H".action = "focus-column-left";
        "Mod+J".action = "focus-window-down";
        "Mod+K".action = "focus-window-up";
        "Mod+L".action = "focus-column-right";
        "Mod+Left".action = "focus-column-left";
        "Mod+Down".action = "focus-window-down";
        "Mod+Up".action = "focus-window-up";
        "Mod+Right".action = "focus-column-right";

        # Window Movement
        "Mod+Shift+H".action = "move-column-left";
        "Mod+Shift+J".action = "move-window-down";
        "Mod+Shift+K".action = "move-window-up";
        "Mod+Shift+L".action = "move-column-right";

        # Workspace Navigation
        "Mod+1".action = { focus-workspace = 1; };
        "Mod+2".action = { focus-workspace = 2; };
        "Mod+3".action = { focus-workspace = 3; };
        "Mod+4".action = { focus-workspace = 4; };
        "Mod+5".action = { focus-workspace = 5; };

        # Move to Workspace
        "Mod+Shift+1".action = { move-column-to-workspace = 1; };
        "Mod+Shift+2".action = { move-column-to-workspace = 2; };
        "Mod+Shift+3".action = { move-column-to-workspace = 3; };
        "Mod+Shift+4".action = { move-column-to-workspace = 4; };
        "Mod+Shift+5".action = { move-column-to-workspace = 5; };

        # Column Width
        "Mod+Minus".action = "set-column-width" "-10%";
        "Mod+Equal".action = "set-column-width" "+10%";

        # Session
        "Mod+Shift+E".action = "quit";
        "Mod+Shift+P".action.spawn = [ "systemctl" "poweroff" ];
      };

      # ------------------------------------------------------------------
      # Window Rules
      # ------------------------------------------------------------------
      window-rules = [
        {
          matches = [{ app-id = "^firefox$"; }];
          default-column-width = { proportion = 0.6; };
        }
        {
          matches = [{ app-id = "^1password$"; }];
          open-floating = true;
        }
        {
          matches = [{ app-id = "^flameshot$"; }];
          open-floating = true;
        }
      ];

      # ------------------------------------------------------------------
      # Animations
      # ------------------------------------------------------------------
      animations = {
        slowdown = 1.0;
        window-open.spring = {
          damping-ratio = 0.8;
          stiffness = 500;
          epsilon = 0.0001;
        };
      };
    };
  };

  # ==========================================================================
  # DankMaterialShell Configuration
  # ==========================================================================

  programs.dank-material-shell = {
    enable = true;

    # Systemd service management
    systemd = {
      enable = false; # Using niri.enableSpawn instead
      restartIfChanged = true;
    };

    # Feature toggles
    enableSystemMonitoring = true;
    enableVPN = false;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = false;
    enableClipboardPaste = true;

    # Niri-specific integration
    niri = {
      enableKeybinds = true;
      enableSpawn = true;

      includes = {
        enable = true;
        override = true;
        originalFileName = "hm";
        filesToInclude = [
          "alttab"
          "binds"
          "colors"
          "layout"
        ];
      };
    };
  };

  # ==========================================================================
  # Additional Niri Companion Tools
  # ==========================================================================

  home.packages = with pkgs; [
    fuzzel
    wl-clipboard
    cliphist
    flameshot
    grim
    slurp
    swaybg
  ];
}
