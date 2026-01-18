{ pkgs, ... }:

{
  # ==========================================================================
  # Display Manager & Desktop Environment
  # ==========================================================================

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Exclude unwanted KDE apps
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kate
  ];
}
