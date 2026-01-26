# macOS M1 Max host configuration
{ pkgs, ... }:

{
  imports = [
    # Darwin system modules
    ../../modules/darwin/system.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/nix.nix
  ];

  # ==========================================================================
  # Primary User (required for user-facing system options)
  # ==========================================================================

  system.primaryUser = "nmod";

  # ==========================================================================
  # Users
  # ==========================================================================

  users.users.nmod = {
    name = "nmod";
    home = "/Users/nmod";
    shell = pkgs.fish;
  };

  # ==========================================================================
  # System Programs
  # ==========================================================================

  programs.fish.enable = true;

  # ==========================================================================
  # Environment
  # ==========================================================================

  environment.systemPackages = with pkgs; [
    vim
    git
  ];
}
