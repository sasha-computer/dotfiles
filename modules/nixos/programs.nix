{ pkgs, ... }:

{
  programs.fish.enable = true;

  # 1Password
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "sasha" ];
  };

  # nix-ld (for running unpatched binaries)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    glib
    openssl
  ];

  # OBS Studio with Wayland/Pipewire support
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs                     # Screen capture for wlroots (Niri)
      obs-pipewire-audio-capture # Audio capture via Pipewire
    ];
  };
}
