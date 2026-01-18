# NixOS Dotfiles TODO

Updated: 2026-01-18

---

## Completed

### Modular Architecture Refactor
**Status:** DONE

Split monolithic configs into focused modules:

```
~/Dotfiles/
├── flake.nix
├── configuration.nix          # 112 lines (was 241)
├── home.nix                   # 33 lines (was 199)
├── firefox.nix
├── hardware-configuration.nix
├── modules/
│   ├── nixos/
│   │   ├── boot.nix           # Bootloader, LUKS
│   │   ├── desktop.nix        # Plasma 6, SDDM, PipeWire
│   │   ├── locale.nix         # Timezone, i18n
│   │   ├── networking.nix     # NetworkManager, firewall
│   │   ├── nix.nix            # Flakes, GC, store optimisation
│   │   ├── programs.nix       # 1Password, ydotool, nix-ld
│   │   ├── security.nix       # Sudo rules
│   │   ├── services.nix       # Printing, Avahi, fwupd
│   │   └── virtualisation.nix # Docker
│   └── home/
│       ├── shell.nix          # Git, SSH, Fish
│       ├── desktop.nix        # Plasma-manager, XDG, autostart
│       ├── browsers.nix       # Tridactyl
│       ├── editors.nix        # Zed
│       └── tools.nix          # Claude, voxtype, syncthing
└── sources/                   # Raw config files
```

### ~~Fix deprecated Git config syntax~~
**Status:** DONE

Updated to new `programs.git.settings` syntax in `modules/home/shell.nix`.

### ~~Add garbage collection~~
**Status:** DONE

Added in `modules/nixos/nix.nix`:
```nix
nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 30d";
};
```

### ~~Enable firmware updates~~
**Status:** DONE

Added in `modules/nixos/services.nix`:
```nix
services.fwupd.enable = true;
```

### ~~Optimise Nix settings~~
**Status:** DONE

Added in `modules/nixos/nix.nix`:
```nix
nix.settings = {
  experimental-features = [ "nix-command" "flakes" ];
  auto-optimise-store = true;
  trusted-users = [ "root" "sasha" ];
};
```

---

## Remaining Tasks

### Medium Priority

#### 1. Consider auto-upgrade (optional)
Automatic system updates (only enable if desired):

```nix
# Add to modules/nixos/nix.nix
system.autoUpgrade = {
  enable = true;
  flake = "/home/sasha/Dotfiles#fw13";
  dates = "weekly";
  allowReboot = false;
};
```

#### 2. Remove redundant terminals
**File:** `configuration.nix`

You have both `warp-terminal` and `ghostty` installed. Consider removing one if not actively using both.

### Nice to Have

#### 3. Add fish aliases declaratively
**File:** `modules/home/shell.nix`

Consider adding common aliases directly:

```nix
programs.fish = {
  shellAliases = {
    nrs = "sudo nixos-rebuild switch --flake ~/Dotfiles#fw13";
  };
};
```

#### 4. Host abstraction (optional)
For multi-host setups, consider:
- Create `hosts/fw13/` directory
- Move hardware-configuration.nix into host
- Consider [flake-parts](https://github.com/hercules-ci/flake-parts) for cleaner flake

#### 5. ~~Battery optimisation with TLP~~
**Status:** SKIP

Modern kernel (6.12.63) and Plasma's power-profiles-daemon provide sufficient power management.

---

## Notes

### Security Consideration
The passwordless sudo for nixos-rebuild (`modules/nixos/security.nix`) allows any process running as your user to modify the system. This is convenient for automation but be aware of the implications.

---

## Resources

- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/modularize-the-configuration)
- [Home Manager](https://github.com/nix-community/home-manager)
- [flake-parts](https://github.com/hercules-ci/flake-parts)
- [NixOS Discourse - Config Structure](https://discourse.nixos.org/t/how-do-you-structure-your-nixos-configs/65851)

---

## Commands

Rebuild and switch:
```bash
nrs
```

Update packages:
```bash
nix flake update && nrs
```
