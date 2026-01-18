# NixOS Dotfiles TODO

Generated: 2026-01-18

---

## Major Refactor: Modular Architecture

### Current State
- `configuration.nix` (241 lines) - Monolithic system config
- `home.nix` (199 lines) - Monolithic user config
- `firefox.nix` - Good example of modular split
- `flake.nix` - Clean but could support multi-host

### Recommended Approach

Based on [community discussion](https://discourse.nixos.org/t/how-do-you-structure-your-nixos-configs/65851), the consensus is: **start simple, expand when complexity demands it**. Your current structure is reasonable for a single-host setup. However, given the growing `configuration.nix`, a moderate refactor would help.

### Proposed Structure

```
~/Dotfiles/
├── flake.nix
├── hosts/
│   └── fw13/
│       ├── default.nix          # Host entry point
│       └── hardware-configuration.nix
├── modules/
│   ├── nixos/                   # System-level modules
│   │   ├── boot.nix
│   │   ├── desktop.nix          # Plasma + SDDM + audio
│   │   ├── networking.nix
│   │   ├── virtualisation.nix
│   │   ├── programs.nix         # 1password, ydotool, nix-ld
│   │   └── nix.nix              # GC, flakes, store optimisation
│   └── home/                    # Home Manager modules
│       ├── shell.nix            # fish, git, ssh
│       ├── desktop.nix          # plasma-manager, autostart
│       ├── browsers.nix         # firefox, tridactyl
│       ├── editors.nix          # zed, neovim dotfiles
│       └── tools.nix            # claude, voxtype, syncthing
├── packages.nix                 # Categorised user packages
└── sources/                     # Raw config files (unchanged)
```

### Modern Tooling Options

**[flake-parts](https://github.com/hercules-ci/flake-parts)** - Framework that uses the module system for cleaner flakes. Major benefit: modular flakes with full power of the module system and proper error handling. Better alternative to flake-utils.

**[sysmodule-flake](https://github.com/applicative-systems/sysmodule-flake)** - Auto-selects config for your machine, eliminates boilerplate. Good for multi-system setups (NixOS + Darwin + home-manager).

For a single-host setup like yours, plain flakes are fine. Consider flake-parts if/when you add more hosts.

### Implementation Steps

#### Phase 1: Extract System Modules (Low Risk)
1. Create `modules/nixos/` directory
2. Extract boot config → `modules/nixos/boot.nix`
3. Extract Plasma/audio → `modules/nixos/desktop.nix`
4. Extract networking → `modules/nixos/networking.nix`
5. Create `modules/nixos/nix.nix` with GC + optimisations (new)
6. Update `configuration.nix` to import modules

#### Phase 2: Organise Packages
1. Create `packages.nix` with categorised lists
2. Import into user config

#### Phase 3: Extract Home Modules
1. Create `modules/home/` directory
2. Extract shell configs (fish, git, ssh)
3. Extract plasma-manager config
4. Extract dotfile deployments by application

#### Phase 4: Host Abstraction (Optional)
1. Create `hosts/fw13/` directory
2. Move hardware-configuration.nix into host
3. Update flake.nix

### Module Pattern Example

Following [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/modularize-the-configuration) patterns:

```nix
# modules/nixos/desktop.nix
{ config, pkgs, ... }:
{
  # Plasma 6
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kate
  ];

  # Audio (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
```

Then in `configuration.nix`:
```nix
imports = [
  ./hardware-configuration.nix
  ./modules/nixos/boot.nix
  ./modules/nixos/desktop.nix
  ./modules/nixos/networking.nix
  # ...
];
```

---

## High Priority

### 1. Fix deprecated Git config syntax
**File:** `home.nix:146-159`

Current `programs.git.settings` is being phased out. Update to use proper Home Manager options:

```nix
programs.git = {
  enable = true;
  userName = "nmod";
  userEmail = "33594434+neutronmoderator@users.noreply.github.com";
  signing = {
    signByDefault = true;
    key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGug35ClTdXh9ege0MmldlDu+xu+EKILrtlqkSbpBhPX";
  };
  extraConfig = {
    gpg.format = "ssh";
    "gpg \"ssh\"".program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
    push.autoSetupRemote = true;
  };
};
```

### 2. Add garbage collection
**File:** `configuration.nix` (or `modules/nixos/nix.nix` after refactor)

Prevent disk bloat from old generations:

```nix
nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 30d";
};
```

### 3. Enable firmware updates
**File:** `configuration.nix`

Important for Framework laptop firmware updates via [fwupd](https://wiki.nixos.org/wiki/Fwupd):

```nix
services.fwupd.enable = true;
```

---

## Medium Priority

### 4. Optimise Nix settings
**File:** `configuration.nix:231-234`

Add performance optimisations:

```nix
nix.settings = {
  experimental-features = [ "nix-command" "flakes" ];
  auto-optimise-store = true;  # Deduplicate store
  trusted-users = [ "root" "sasha" ];  # For binary cache
};
```

### 5. Consider auto-upgrade (optional)
**File:** `configuration.nix`

Automatic system updates (only enable if desired):

```nix
system.autoUpgrade = {
  enable = true;
  flake = "/home/sasha/Dotfiles#fw13";
  dates = "weekly";
  allowReboot = false;
};
```

### 6. Remove redundant terminals
**File:** `configuration.nix:136-138`

You have both `warp-terminal` and `ghostty` installed. Consider removing one if not actively using both.

---

## Nice to Have

### 7. Add fish aliases declaratively
**File:** `home.nix:173-182`

Instead of sourcing config.fish, consider adding common aliases in home.nix:

```nix
programs.fish = {
  enable = true;
  shellAliases = {
    nrs = "sudo nixos-rebuild switch --flake ~/Dotfiles#fw13";
    # Add other aliases from sources/config.fish
  };
  plugins = [
    {
      name = "z";
      src = pkgs.fishPlugins.z.src;
    }
  ];
  interactiveShellInit = builtins.readFile ./sources/config.fish;
};
```

### 8. ~~Battery optimisation with TLP~~
**Status:** SKIP - Not needed for Framework + Plasma 6 + modern kernel

Modern kernel (6.12.63) and Plasma's power-profiles-daemon provide sufficient power management. Only revisit if experiencing battery issues.

---

## Notes

### Security Consideration
The passwordless sudo for nixos-rebuild (configuration.nix:74-84) allows any process running as your user to modify the system. This is convenient for automation but be aware of the security implications.

### Overall Assessment
Dotfiles are well-structured and follow modern NixOS patterns. Main issues are deprecated git syntax and missing garbage collection. The modular refactor is optional but recommended as the config grows.

---

## Resources

- [NixOS & Flakes Book - Modularize Configuration](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/modularize-the-configuration)
- [Home Manager Manual](https://github.com/nix-community/home-manager)
- [flake-parts](https://github.com/hercules-ci/flake-parts)
- [NixOS Discourse - Config Structure Discussion](https://discourse.nixos.org/t/how-do-you-structure-your-nixos-configs/65851)
- [2025 Dotfiles Example](https://discourse.nixos.org/t/my-2025-dotfiles-home-manager-nix-darwin-nixos-terraform-kubernetes-on-vms/73690)
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles) - Well-organised NixOS + Home Manager example

---

## Updating Process

After making changes:

```bash
cd ~/Dotfiles
nrs  # Rebuild and switch
```

To update packages:

```bash
cd ~/Dotfiles
nix flake update
nrs
```
