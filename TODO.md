# NixOS Dotfiles TODO

Updated: 2026-01-18

---

## All Tasks Complete! 🎉

### Modular Architecture
- ✅ System modules in `modules/nixos/`
- ✅ Home modules in `modules/home/`
- ✅ Host abstraction in `hosts/fw13/`

### Configuration
- ✅ Fish aliases declarative in `modules/home/shell.nix`
- ✅ Git using new `settings` syntax
- ✅ Garbage collection (weekly, 30d retention)
- ✅ Auto-upgrade (weekly, no auto-reboot)
- ✅ fwupd for Framework firmware
- ✅ Nix store optimisation

---

## Current Structure

```
~/Dotfiles/
├── flake.nix
├── hosts/
│   └── fw13/
│       ├── default.nix              # Host config + user packages
│       └── hardware-configuration.nix
├── modules/
│   ├── nixos/
│   │   ├── boot.nix, desktop.nix, locale.nix
│   │   ├── networking.nix, nix.nix, programs.nix
│   │   ├── security.nix, services.nix, virtualisation.nix
│   └── home/
│       ├── shell.nix, desktop.nix, browsers.nix
│       ├── editors.nix, tools.nix
├── home.nix                         # Home Manager entry
├── firefox.nix
└── sources/                         # Raw config files
```

---

## Adding a New Host

1. Create `hosts/<hostname>/default.nix`
2. Create or generate `hosts/<hostname>/hardware-configuration.nix`
3. Add to `flake.nix`:
   ```nix
   nixosConfigurations.<hostname> = nixpkgs.lib.nixosSystem {
     inherit system;
     modules = [ ./hosts/<hostname> ... ];
   };
   ```

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

---

## Resources

- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)
- [Home Manager](https://github.com/nix-community/home-manager)
- [flake-parts](https://github.com/hercules-ci/flake-parts)
