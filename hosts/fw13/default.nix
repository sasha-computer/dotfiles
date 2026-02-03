# Framework 13 (fw13) host configuration
{ pkgs, lib, desktopEnvironment, ... }:

let
  # Wrap RuneLite with Java AWT fix for Wayland/XWayland
  runelite-wrapped = pkgs.symlinkJoin {
    name = "runelite-wrapped";
    paths = [ pkgs.runelite ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/runelite \
        --set _JAVA_AWT_WM_NONREPARENTING 1
    '';
  };
in {
  imports = [
    ./hardware-configuration.nix

    # Home Manager & Firefox
    ../../home.nix
    ../../firefox.nix

    # Modular NixOS configuration
    ../../modules/nixos/boot.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/desktop-common.nix
    ../../modules/nixos/security.nix
    ../../modules/nixos/services.nix
    ../../modules/nixos/virtualisation.nix
    ../../modules/nixos/programs.nix
    ../../modules/nixos/nix.nix
  ]
  # Conditional desktop imports
  ++ (if desktopEnvironment == "plasma"
      then [ ../../modules/nixos/desktop-plasma.nix ]
      else [ ../../modules/nixos/desktop-niri.nix ]);

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
      nodejs
      bun
      uv
      cargo
      rustc
      rust-analyzer
      rustPlatform.rustLibSrc
      nixd
      nil
      claude-code
      opencode
      gh
      code-cursor
      cursor-cli
      awscli2
      flyctl

      # Communication
      slack
      signal-desktop-bin
      telegram-desktop
      vesktop

      # Applications
      kdePackages.dolphin
      obsidian
      spotify
      rclone
      vlc
      localsend
      todoist-electron
      helium

      # Games
      bolt-launcher
      runelite-wrapped

      # XWayland for Electron apps (Cursor, etc.)
      xwayland-satellite

      # Tools
      unzip
      dust
      jq
      fzf
      ripgrep
      gum
      imagemagick

      # Whisper push-to-talk
      whisper-cpp
      wtype
      ffmpeg

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
