{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
in
{
  imports =
    [
      (import "${home-manager}/nixos")
    ];

  home-manager.backupFileExtension = "bak";

  home-manager.users.sasha = {

    xdg.configFile."1Password/ssh/agent.toml".text = ''
	[[ssh-keys]]
	vault = "Identity"
    '';

    programs.fish = {
	enable = true;
	shellAliases = {
		ll = "ls -l";
		gl = "git log --oneline";
	};
	interactiveShellInit = ''
		set -gx SSH_AUTH_SOCK ~/.1password/agent.sock
	'';
    };

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

    programs.git = {
    	enable = true;
	settings = {
		user.name = "nmod";
		user.email = "33594434+neutronmoderator@users.noreply.github.com";
      		gpg.format = "ssh";
		"gpg \"ssh\"" = {
			program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
		};
		commit.gpgsign = true;
		user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGug35ClTdXh9ege0MmldlDu+xu+EKILrtlqkSbpBhPX";
      	};
    };

    home.stateVersion = "25.11";
  };
}
