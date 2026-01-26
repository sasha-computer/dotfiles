{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    niri-flake.url = "github:sodiboo/niri-flake";

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      plasma-manager,
      niri-flake,
      dms,
      helium,
      ...
    }:
    let
      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";
      desktopEnvironment = "niri"; # "plasma" or "niri"
    in
    {
      # ==========================================================================
      # NixOS Configuration (Linux)
      # ==========================================================================

      nixosConfigurations.fw13 = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        specialArgs = { inherit desktopEnvironment; };
        modules = [
          ./hosts/fw13
          home-manager.nixosModules.home-manager
          {
            home-manager.sharedModules =
              (if desktopEnvironment == "plasma" then [
                plasma-manager.homeModules.plasma-manager
              ] else [
                niri-flake.homeModules.niri
                dms.homeModules.dank-material-shell
                dms.homeModules.niri
              ]);

            home-manager.extraSpecialArgs = { inherit desktopEnvironment; };

            nixpkgs.overlays = [
              (final: prev: {
                helium = helium.packages.${prev.stdenv.hostPlatform.system}.default;
              })
              niri-flake.overlays.niri
            ];
          }
        ];
      };

      # ==========================================================================
      # Darwin Configuration (macOS)
      # ==========================================================================

      darwinConfigurations.m1-max = nix-darwin.lib.darwinSystem {
        system = darwinSystem;
        modules = [
          ./hosts/m1-max
          ./home-darwin.nix
          home-manager.darwinModules.home-manager
        ];
      };
    };
}
