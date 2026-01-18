{
  pkgs,
  lib,
  ...
}:

{
  home-manager.backupFileExtension = "bak";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.sasha = {
    imports = [
      ./modules/home/shell.nix
      ./modules/home/desktop.nix
      ./modules/home/editors.nix
      ./modules/home/browsers.nix
      ./modules/home/tools.nix
    ];

    # ==========================================================================
    # Environment Variables
    # ==========================================================================

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    # ==========================================================================
    # Version
    # ==========================================================================

    home.stateVersion = "25.11";
  };
}
