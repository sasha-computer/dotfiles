{ pkgs, ... }:

{
  # ==========================================================================
  # Shell
  # ==========================================================================

  programs.fish.enable = true;

  # ==========================================================================
  # 1Password
  # ==========================================================================

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "sasha" ];
  };

  # ==========================================================================
  # ydotool (for voxtype - wtype doesn't work on KDE Wayland)
  # ==========================================================================

  programs.ydotool.enable = true;

  # ==========================================================================
  # nix-ld (for running unpatched binaries)
  # ==========================================================================

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    glib
    openssl
  ];
}
