# Common shell configuration shared between Linux and macOS
{
  pkgs,
  lib,
  config,
  ...
}:

{
  # ==========================================================================
  # Git (shared across platforms)
  # ==========================================================================

  programs.git = {
    enable = true;
    signing = {
      signByDefault = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGug35ClTdXh9ege0MmldlDu+xu+EKILrtlqkSbpBhPX";
    };
    settings = {
      user.name = "nmod";
      user.email = "33594434+neutronmoderator@users.noreply.github.com";
      gpg.format = "ssh";
      push.autoSetupRemote = true;
    };
  };

  # ==========================================================================
  # SSH (base config, socket path set by platform-specific module)
  # ==========================================================================

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
  };

  # ==========================================================================
  # Fish (shared aliases and plugins)
  # ==========================================================================

  programs.fish = {
    enable = true;
    shellAliases = {
      # Git
      gl = "git log --oneline";
      gcm = "git commit -m";
      gaa = "git add .";
      gs = "git status";
      gfp = "git fetch --prune";
      gpl = "git pull";
      gp = "git push";
      gc = "git checkout";
      gcb = "git checkout -b";
      gcl = "git clone";
      grv = "git remote -v";

      # Navigation & Tools
      ll = "ls -l";
      cdd = "cd ~/Developer/";
      cc = "claude --allow-dangerously-skip-permissions";
      "z." = "zeditor .";
    };
    plugins = [
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
    ];
  };
}
