# Nixvim is a NixOS module that installs and configures Neovim
{ inputs, ... }:
{
  imports = [ ./nvim.nix ];
  programs.neovim = {
  	enable = true;
	  viAlias = true;
	  vimAlias = true;
	  vimdiffAlias = true;
    coc.enable = true;
    defaultEditor = true;
  };
}
