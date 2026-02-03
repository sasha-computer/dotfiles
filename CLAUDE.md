# NixOS Dotfiles

Niri + DMS desktop, Home Manager for user config.

## Commands
```sh
nrs                      # Rebuild and switch
nix flake update && nrs  # Update packages
```

## Structure
hosts/fw13/ → Host config, user packages
modules/nixos/ → System modules
modules/home/ → Home Manager modules
sources/ → Raw config files (deployed via home.file)

## Constraints
- Git signing via 1Password (`op-ssh-sign`)
- useGlobalPkgs enabled (overlays/allowUnfree shared)
