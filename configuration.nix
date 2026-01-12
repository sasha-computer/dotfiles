{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./home.nix
    ./firefox.nix
  ];

  # ==========================================================================
  # Boot
  # ==========================================================================

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-1efcba1a-5db4-42d7-9af3-25c9ccf2e748".device =
    "/dev/disk/by-uuid/1efcba1a-5db4-42d7-9af3-25c9ccf2e748";

  # ==========================================================================
  # Networking
  # ==========================================================================

  networking.hostName = "fw13";
  networking.networkmanager.enable = true;

  # LocalSend discovery and file transfer
  networking.firewall = {
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
  };

  # ==========================================================================
  # Localisation
  # ==========================================================================

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # ==========================================================================
  # Desktop Environment
  # ==========================================================================

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Exclude unwanted KDE apps
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kate
  ];

  # ==========================================================================
  # Audio
  # ==========================================================================

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ==========================================================================
  # Services
  # ==========================================================================

  services.printing.enable = true;

  # ==========================================================================
  # Users
  # ==========================================================================

  users.users.sasha = {
    isNormalUser = true;
    description = "sasha";
    extraGroups = [
      "networkmanager"
      "wheel"
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

      # Development
      bun
      uv
      cargo
      rustc
      nixd
      nil
      claude-code

      # Communication
      slack
      signal-desktop-bin
      telegram-desktop

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
    ];
  };

  # ==========================================================================
  # Programs
  # ==========================================================================

  programs.fish.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "sasha" ];
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    glib
    openssl
  ];

  # ==========================================================================
  # System Packages
  # ==========================================================================

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  # ==========================================================================
  # Nix Settings
  # ==========================================================================

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # ==========================================================================
  # System
  # ==========================================================================

  system.stateVersion = "25.11";
}
