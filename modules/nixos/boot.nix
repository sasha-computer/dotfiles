{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-1efcba1a-5db4-42d7-9af3-25c9ccf2e748".device =
    "/dev/disk/by-uuid/1efcba1a-5db4-42d7-9af3-25c9ccf2e748";
}
