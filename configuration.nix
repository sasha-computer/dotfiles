{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./home.nix
    ./firefox.nix

    # Modular NixOS configuration
    ./modules/nixos/boot.nix
    ./modules/nixos/networking.nix
    ./modules/nixos/locale.nix
    ./modules/nixos/desktop.nix
    ./modules/nixos/security.nix
    ./modules/nixos/services.nix
    ./modules/nixos/virtualisation.nix
    ./modules/nixos/programs.nix
    ./modules/nixos/nix.nix
  ];

  # ==========================================================================
  # Users
  # ==========================================================================

  users.users.sasha = {
    isNormalUser = true;
    description = "sasha";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "ydotool"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      # Editors
      neovim
      zed-editor

      # Terminal
      ghostty
      fish
      warp-terminal
      btop
      tmux

      # Development
      bun
      uv
      cargo
      rustc
      rust-analyzer
      rustPlatform.rustLibSrc
      nixd
      nil
      claude-code
      gh
      code-cursor

      # Communication
      slack
      signal-desktop-bin
      telegram-desktop
      discord

      # Applications
      obsidian
      spotify
      rclone
      vlc
      localsend

      # Games
      bolt-launcher
      runelite

      # Voice to text
      voxtype
      wtype # for typing on Wayland
      wl-clipboard # for clipboard on Wayland

      # Screenshots
      flameshot

      # Tools
      unzip
      dust
      jq
      fzf
      ripgrep
      gum

      # Fonts
      powerline-fonts
    ];
  };

  # ==========================================================================
  # System Packages
  # ==========================================================================

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  # ==========================================================================
  # System
  # ==========================================================================

  system.stateVersion = "25.11";
}
