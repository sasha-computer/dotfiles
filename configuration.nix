{ config, pkgs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./home.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-1efcba1a-5db4-42d7-9af3-25c9ccf2e748".device = "/dev/disk/by-uuid/1efcba1a-5db4-42d7-9af3-25c9ccf2e748";
  networking.hostName = "fw13"; 
  networking.networkmanager.enable = true;
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

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.sasha = {
    isNormalUser = true;
    description = "sasha";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      kdePackages.kate
      neovim
      obsidian
      ghostty
      rclone
      bolt-launcher
      runelite
      fish
      slack
      signal-desktop-bin
      telegram-desktop
      claude-code
      zed-editor
      bun
      uv
      cargo
      rustc
      spotify
      brave
      nixd
      nil
    ];
  };

  programs.firefox.enable = true;
  programs.fish.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
	enable = true;
	polkitPolicyOwners = [ "sasha" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
     vim
     git
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    glib
    openssl
  ];
  system.stateVersion = "25.11"; 

}
