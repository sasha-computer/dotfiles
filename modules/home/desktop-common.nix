{ ... }:

{
  # ==========================================================================
  # Default Applications (shared between DEs)
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
  # Autostart Applications (common to both DEs)
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
  };
}
