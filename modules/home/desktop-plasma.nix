{ ... }:

{
  # ==========================================================================
  # Plasma (via plasma-manager)
  # ==========================================================================

  programs.plasma = {
    enable = true;

    # Start with empty session (don't restore windows from last session)
    configFile."ksmserverrc"."General"."loginMode" = "emptySession";

    # Disable focus stealing prevention so Firefox pops up when opening links
    # from terminal (Plasma 6 / Wayland XDG activation token limitation)
    # Levels: 0=None, 1=Low, 2=Medium (default), 3=High, 4=Extreme
    configFile."kwinrc"."Windows"."FocusStealingPreventionLevel" = 0;

    hotkeys.commands = {
    };
  };
}
