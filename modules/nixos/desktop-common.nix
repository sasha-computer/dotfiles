{ pkgs, ... }:

{
  # ==========================================================================
  # X Server Basics (needed for XWayland)
  # ==========================================================================

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # ==========================================================================
  # Audio (PipeWire) - Shared between all desktop environments
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
