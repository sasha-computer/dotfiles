# CLAUDE.md

NixOS dotfiles for Framework 13 laptop. Plasma 6 desktop, Home Manager for user config.

## Commands

```sh
nrs                    # Rebuild and switch
nix flake update && nrs  # Update packages
```

## Structure

```
hosts/fw13/            # Host-specific (hardware, user packages)
modules/nixos/         # System modules (boot, desktop, networking, nix, etc.)
modules/home/          # Home Manager modules (shell, desktop, editors, tools)
home.nix               # Home Manager entry point
firefox.nix            # Firefox policies/extensions
sources/               # Raw config files deployed via home.file
```

## Key Files

| What | Where |
|------|-------|
| User packages | `hosts/fw13/default.nix` |
| System services | `modules/nixos/services.nix` |
| Fish aliases | `modules/home/shell.nix` |
| Git/SSH config | `modules/home/shell.nix` |
| Plasma hotkeys | `modules/home/desktop.nix` |
| Nix settings, GC, auto-upgrade | `modules/nixos/nix.nix` |

## Patterns

- **Modular**: Each concern in its own `.nix` file
- **Host-based**: `hosts/<name>/` for multi-machine support
- **Declarative aliases**: Fish aliases in `shellAliases`, not scripts
- **useGlobalPkgs**: Home Manager shares system's pkgs (for overlays, allowUnfree)
- **Git signing**: SSH key via 1Password (`op-ssh-sign`)

## Adding a Host

1. Create `hosts/<name>/default.nix` and `hardware-configuration.nix`
2. Add to `flake.nix`: `nixosConfigurations.<name> = ...`
