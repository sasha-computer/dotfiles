{
  pkgs,
  lib,
  ...
}:

{
  # ==========================================================================
  # Git (using new settings syntax)
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
      "gpg \"ssh\"".program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      push.autoSetupRemote = true;
    };
  };

  # ==========================================================================
  # SSH
  # ==========================================================================

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        extraOptions = {
          IdentityAgent = "~/.1password/agent.sock";
        };
      };
    };
  };

  # ==========================================================================
  # Bash (for Claude Code and other non-fish shells)
  # ==========================================================================

  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/Dotfiles#fw13";
    };
  };

  # ==========================================================================
  # Fish
  # ==========================================================================

  programs.fish = {
    enable = true;
    shellAliases = {
      # NixOS
      nrs = "sudo nixos-rebuild switch --flake ~/Dotfiles#fw13";

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
      cc = "${lib.getExe pkgs.claude-code} --allow-dangerously-skip-permissions";
      "z." = "zeditor .";
      cfg = "cd ~/Dotfiles/ && ${lib.getExe pkgs.claude-code} --dangerously-skip-permissions";
    };
    plugins = [
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
    ];
    interactiveShellInit = builtins.readFile ../../sources/config.fish;
  };

  # ==========================================================================
  # Session Environment Variables
  # ==========================================================================

  # Java AWT fix for non-reparenting window managers (Niri)
  # Fixes tiling/rendering issues with Java Swing apps like RuneLite
  home.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # Add custom scripts to PATH
  home.sessionPath = [ "$HOME/Dotfiles/scripts" ];
}
