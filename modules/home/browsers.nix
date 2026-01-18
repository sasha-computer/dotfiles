{ pkgs, ... }:

{
  home.file = {
    # Tridactyl
    ".config/tridactyl/tridactylrc".source = ../../sources/tridactylrc;
    ".mozilla/native-messaging-hosts/tridactyl.json".source =
      "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";
  };
}
