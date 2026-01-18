{ ... }:

{
  # ==========================================================================
  # Default Applications
  # ==========================================================================

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

  # ==========================================================================
  # Plasma (via plasma-manager)
  # ==========================================================================

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

  # ==========================================================================
  # Autostart Applications
  # ==========================================================================

  home.file = {
    # Autostart 1Password on login (for SSH agent)
    ".config/autostart/1password.desktop".text = ''
      [Desktop Entry]
      Name=1Password
      Exec=1password --silent
      Terminal=false
      Type=Application
      StartupNotify=false
      X-GNOME-Autostart-enabled=true
      X-systemd-Restart=on-failure
      X-systemd-RestartSec=5
    '';

    # Autostart voxtype daemon (voice-to-text)
    ".config/autostart/voxtype.desktop".text = ''
      [Desktop Entry]
      Name=Voxtype
      Exec=voxtype daemon
      Terminal=false
      Type=Application
      StartupNotify=false
      X-GNOME-Autostart-enabled=true
    '';
  };
}
