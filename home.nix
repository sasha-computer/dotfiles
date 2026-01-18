{ desktopEnvironment, ... }:

{
  home-manager.backupFileExtension = "bak";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.sasha = {
    imports = [
      ./modules/home/shell.nix
      ./modules/home/desktop-common.nix
      ./modules/home/editors.nix
      ./modules/home/browsers.nix
      ./modules/home/tools.nix
    ]
    # Conditional desktop imports
    ++ (if desktopEnvironment == "plasma"
        then [ ./modules/home/desktop-plasma.nix ]
        else [ ./modules/home/desktop-niri.nix ]);

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
