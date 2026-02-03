{ pkgs, ... }:

{
  # Electron apps on Wayland (Discord, VSCode, etc.)
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # ==========================================================================
  # Suspend/Resume fixes for Framework 13
  # ==========================================================================

  # Fix touchpad not working after resume (known Framework 13 issue)
  systemd.services.fix-touchpad-resume = {
    description = "Reload touchpad driver after resume";
    after = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
    wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.kmod}/bin/modprobe -r i2c_hid_acpi && ${pkgs.kmod}/bin/modprobe i2c_hid_acpi'";
    };
  };

  # Ignore lid close (laptop used docked with external monitor)
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  # ==========================================================================
  # Printing
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
  };

  # Avahi (network discovery)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Firmware updates (important for Framework laptop)
  services.fwupd.enable = true;

  # UPower (battery status for status bars)
  services.upower.enable = true;

  # Tailscale VPN
  services.tailscale.enable = true;

  # ==========================================================================
  # Removable Media
  # ==========================================================================

  # udisks2 backend for USB mounting (udiskie uses this)
  services.udisks2.enable = true;

  # ==========================================================================
  # Input Simulation (for whisper-ptt, etc.)
  # ==========================================================================

  # ydotool daemon for typing from scripts (works on Wayland)
  programs.ydotool.enable = true;
}
