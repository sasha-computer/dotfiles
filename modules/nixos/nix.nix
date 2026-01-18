{ ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    trusted-users = [ "root" "sasha" ];
  };

  # Garbage collection - prevent disk bloat from old generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Automatic system upgrades (weekly, no auto-reboot)
  system.autoUpgrade = {
    enable = true;
    flake = "/home/sasha/Dotfiles#fw13";
    dates = "weekly";
    allowReboot = false;
  };
}
