{ pkgs, lib, ... }:

{
  # Niri system requirements (compositor configured via home-manager)
  security.polkit.enable = true;
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;
  hardware.graphics.enable = true;
  security.pam.services.swaylock = { };

  # greetd display manager
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
      user = "greeter";
    };
  };
  services.displayManager.sddm.enable = lib.mkForce false;

  # XDG portals
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome  # File picker, etc.
      pkgs.xdg-desktop-portal-wlr    # Screen capture for wlroots
    ];
    config.common.default = "*";
  };

  # DMS dependencies
  services.accounts-daemon.enable = true;
  services.power-profiles-daemon.enable = true;
}
