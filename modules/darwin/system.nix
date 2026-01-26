# macOS system preferences and settings
{ ... }:

{
  # ==========================================================================
  # Dock
  # ==========================================================================

  system.defaults.dock = {
    autohide = true;
    minimize-to-application = true;
    show-recents = false;
    mru-spaces = false;
    tilesize = 48;
  };

  # ==========================================================================
  # Finder
  # ==========================================================================

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    FXPreferredViewStyle = "Nlsv"; # List view
    ShowPathbar = true;
    ShowStatusBar = true;
    _FXShowPosixPathInTitle = true;
  };

  # ==========================================================================
  # Trackpad
  # ==========================================================================

  system.defaults.trackpad = {
    Clicking = true; # Tap to click
    TrackpadThreeFingerDrag = true;
  };

  system.defaults.NSGlobalDomain = {
    # ==========================================================================
    # Keyboard
    # ==========================================================================

    KeyRepeat = 2; # Fast key repeat
    InitialKeyRepeat = 15; # Short delay until repeat
    ApplePressAndHoldEnabled = false; # Disable press-and-hold for keys

    # ==========================================================================
    # Mouse & Trackpad
    # ==========================================================================

    "com.apple.swipescrolldirection" = true; # Natural scrolling
    "com.apple.mouse.tapBehavior" = 1; # Tap to click

    # ==========================================================================
    # Window Management
    # ==========================================================================

    NSAutomaticWindowAnimationsEnabled = false;
    NSWindowResizeTime = 0.001;

    # ==========================================================================
    # General UI
    # ==========================================================================

    AppleInterfaceStyleSwitchesAutomatically = true; # Auto dark mode
    AppleShowScrollBars = "WhenScrolling";
  };

  # ==========================================================================
  # Screenshots
  # ==========================================================================

  system.defaults.screencapture = {
    location = "~/Screenshots";
    disable-shadow = true;
    type = "png";
  };

  # ==========================================================================
  # Security
  # ==========================================================================

  security.pam.services.sudo_local.touchIdAuth = true;

  # ==========================================================================
  # System State
  # ==========================================================================

  system.stateVersion = 6;
}
