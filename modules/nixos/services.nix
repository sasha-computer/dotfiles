{ pkgs, ... }:

{
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
}
