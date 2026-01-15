{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    voxtype = {
      url = "github:peteonrails/voxtype";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      plasma-manager,
      voxtype,
      ...
    }:
    let
      system = "x86_64-linux";
      unstable = import nixpkgs-unstable { inherit system; };
    in
    {
      nixosConfigurations.fw13 = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.sharedModules = [
              plasma-manager.homeModules.plasma-manager
            ];
            nixpkgs.overlays = [
              (final: prev: {
                voxtype = voxtype.packages.${prev.system}.default;
                unstable = unstable;
              })
            ];
          }
        ];
      };
    };
}
