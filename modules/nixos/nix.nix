{ ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    trusted-users = [ "root" "sasha" ];
    max-free = 3221225472;  # 3GB - trigger GC when store exceeds
    min-free = 536870912;   # 512MB - minimum free space
  };

  # Garbage collection - prevent disk bloat from old generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Automatic system upgrades (weekly, no auto-reboot)
  system.autoUpgrade = {
    enable = true;
    flake = "/home/sasha/Dotfiles#fw13";
    dates = "weekly";
    allowReboot = false;
  };
}
