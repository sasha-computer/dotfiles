{ ... }:

{
  home.file = {
    # Zed
    ".config/zed/settings.json".source = ../../sources/zed-settings.json;
    ".config/zed/keymap.json".source = ../../sources/zed-keymap.json;
  };
}
