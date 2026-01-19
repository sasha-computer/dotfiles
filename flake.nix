{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
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
      plasma-manager,
      niri-flake,
      dms,
      helium,
      ...
    }:
    let
      system = "x86_64-linux";
      desktopEnvironment = "niri"; # "plasma" or "niri"
    in
    {
      nixosConfigurations.fw13 = nixpkgs.lib.nixosSystem {
        inherit system;
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
    };
}
