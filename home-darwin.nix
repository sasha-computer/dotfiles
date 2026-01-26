# Home Manager configuration for macOS
{ pkgs, ... }:

{
  home-manager.backupFileExtension = "bak";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.nmod = {
    imports = [
      ./modules/home/shell/shell-common.nix
      ./modules/home/shell/shell-darwin.nix
      ./modules/home/editors.nix
      ./modules/home/tools-common.nix
      ./modules/home/tools-darwin.nix
    ];

    # ==========================================================================
    # Environment Variables
    # ==========================================================================

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    # ==========================================================================
    # User Packages (via home-manager)
    # ==========================================================================

    home.packages = with pkgs; [
      # Development tools available via nix
      bun
      uv
      nixd
      nil
      claude-code
      gh

      # Tools
      jq
      fzf
      ripgrep
      dust
    ];

    # ==========================================================================
    # Version
    # ==========================================================================

    home.stateVersion = "25.11";
  };
}
