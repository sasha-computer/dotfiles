{
  inputs = {
    # Using unstable for fresher packages (Cursor, Warp, etc.)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager master to match unstable nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Niri compositor with native Nix configuration
    niri-flake.url = "github:sodiboo/niri-flake";

    # DankMaterialShell for full desktop experience on Niri
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    voxtype = {
      url = "github:peteonrails/voxtype";
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
      voxtype,
      helium,
      ...
    }:
    let
      system = "x86_64-linux";

      # ============================================================
      # SWITCH DESKTOP HERE: "plasma" or "niri"
      # ============================================================
      desktopEnvironment = "niri";
    in
    {
      nixosConfigurations.fw13 = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit desktopEnvironment; };
        modules = [
          ./hosts/fw13
          home-manager.nixosModules.home-manager

          # Conditional: niri NixOS module
          (if desktopEnvironment == "niri" then niri-flake.nixosModules.niri else { })

          {
            home-manager.sharedModules =
              # Conditional: plasma-manager OR niri+dms modules
              (if desktopEnvironment == "plasma" then [
                plasma-manager.homeModules.plasma-manager
              ] else [
                niri-flake.homeModules.niri
                niri-flake.homeModules.config
                dms.homeModules.dank-material-shell
                dms.homeModules.niri
              ]);

            home-manager.extraSpecialArgs = { inherit desktopEnvironment; };

            nixpkgs.overlays = [
              (final: prev: {
                voxtype = voxtype.packages.${prev.stdenv.hostPlatform.system}.default;
                helium = helium.packages.${prev.stdenv.hostPlatform.system}.default;
              })
              niri-flake.overlays.niri
            ];
          }
        ];
      };
    };
}
