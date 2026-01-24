{ pkgs, ... }:

{
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

  # Ensure lid close triggers suspend
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
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
}
