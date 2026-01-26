# CLAUDE.md

Cross-platform Nix dotfiles for NixOS (Framework 13) and macOS (M1 Max). Uses nix-darwin for macOS, Home Manager for user config.

## Commands

```sh
# Linux (NixOS)
nrs                      # Rebuild and switch
nix flake update && nrs  # Update packages

# macOS (nix-darwin)
drs                      # Rebuild and switch
nix flake update && drs  # Update packages
```

## Structure

```
hosts/fw13/              # NixOS host (Framework 13)
hosts/m1-max/            # macOS host (M1 Max)
modules/nixos/           # NixOS system modules
modules/darwin/          # macOS system modules (system.nix, homebrew.nix, nix.nix)
modules/home/            # Home Manager modules (shared + platform-specific)
modules/home/shell/      # Shell config (common, linux, darwin)
home.nix                 # Home Manager entry (Linux)
home-darwin.nix          # Home Manager entry (macOS)
sources/                 # Raw config files deployed via home.file
```

## Key Files

| What | Where |
|------|-------|
| User packages (Linux) | `hosts/fw13/default.nix` |
| User packages (macOS) | `home-darwin.nix` |
| Homebrew casks/brews | `modules/darwin/homebrew.nix` |
| macOS system prefs | `modules/darwin/system.nix` |
| Fish aliases (common) | `modules/home/shell/shell-common.nix` |
| Fish aliases (Linux) | `modules/home/shell/shell-linux.nix` |
| Fish aliases (macOS) | `modules/home/shell/shell-darwin.nix` |
| Git/SSH config | `modules/home/shell/shell-*.nix` |

## Platform Differences

| Config | Linux | macOS |
|--------|-------|-------|
| 1Password socket | `~/.1password/agent.sock` | `~/Library/Group Containers/.../agent.sock` |
| Rebuild alias | `nrs` | `drs` |
| op-ssh-sign | via pkgs | `/Applications/1Password.app/.../op-ssh-sign` |

## Practices

- **Modular**: Each concern in its own `.nix` file
- **Cross-platform**: Shared modules + platform-specific overrides
- **Host-based**: `hosts/<name>/` for multi-machine support
- **Declarative Homebrew**: Casks and brews managed via nix-darwin
- **useGlobalPkgs**: Home Manager shares system's pkgs
- **Git signing**: SSH key via 1Password (`op-ssh-sign`)

## Adding a Host

**NixOS:**
1. Create `hosts/<name>/default.nix` and `hardware-configuration.nix`
2. Add to `flake.nix`: `nixosConfigurations.<name> = ...`

**macOS:**
1. Create `hosts/<name>/default.nix` importing darwin modules
2. Add to `flake.nix`: `darwinConfigurations.<name> = ...`
