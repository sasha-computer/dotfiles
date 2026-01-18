{ pkgs, lib, ... }:

{
  # ==========================================================================
  # Niri Compositor (via niri-flake nixosModule)
  # ==========================================================================

  # niri-flake's nixosModule automatically:
  # - Installs niri with systemd units
  # - Enables polkit (KDE agent by default)
  # - Configures xdg-desktop-portal-gnome for screencasting
  # - Enables GNOME keyring, dconf, OpenGL
  # - Adds PAM entry for swaylock

  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-stable;

  # ==========================================================================
  # Display Manager - greetd with tuigreet
  # ==========================================================================

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
        user = "greeter";
      };
    };
  };

  # Disable SDDM (ensure no conflict)
  services.displayManager.sddm.enable = lib.mkForce false;

  # ==========================================================================
  # XDG Portals for Niri
  # ==========================================================================

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  # ==========================================================================
  # DMS Dependencies
  # ==========================================================================

  services.accounts-daemon.enable = true;
  services.power-profiles-daemon.enable = true;
}
