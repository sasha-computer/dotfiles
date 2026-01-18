{ ... }:

{
  # Allow passwordless nixos-rebuild (for Claude Code automation)
  security.sudo.extraRules = [
    {
      users = [ "sasha" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
