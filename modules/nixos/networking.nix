{ ... }:

{
  networking.hostName = "fw13";
  networking.networkmanager.enable = true;

  # LocalSend discovery and file transfer
  networking.firewall = {
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
  };
}
