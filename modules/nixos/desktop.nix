{ pkgs, ... }:

{
  # ==========================================================================
  # Display & Desktop Environment
  # ==========================================================================

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Exclude unwanted KDE apps
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kate
  ];

  # ==========================================================================
  # Audio (PipeWire)
  # ==========================================================================

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
