# Declarative Homebrew management via nix-darwin
{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap"; # Remove unlisted apps
      autoUpdate = true;
      upgrade = true;
    };

    # ==========================================================================
    # Homebrew Formulas (CLI tools)
    # ==========================================================================

    brews = [
      "bash"
      "btop"
      "cmake"
      "fish"
      "gh"
      "helix"
      "tmux"
      "wireguard-tools"
      "signalbackup-tools"
    ];

    # ==========================================================================
    # Homebrew Casks (GUI applications)
    # ==========================================================================

    casks = [
      # Browsers
      "arc"
      "zen"

      # Development
      "ghostty"
      "warp"
      "zed"
      "claude"

      # Communication
      "signal"
      "slack"
      "telegram"
      "thunderbird"

      # Productivity
      "1password"
      "obsidian"
      "raycast"
      "todoist-app"
      "standard-notes"

      # Media
      "spotify"

      # Utilities
      "balenaetcher"
      "cap"
      "helium-browser"
      "localsend"
      "lulu"
      "proton-mail-bridge"
      "swish"
    ];

    # ==========================================================================
    # Mac App Store (via mas)
    # ==========================================================================

    masApps = {
      # Add Mac App Store apps here if needed
      # "App Name" = 123456789;
    };
  };
}
