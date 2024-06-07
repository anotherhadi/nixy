{ pkgs, config, ... }:

let
  homedir = config.home.homeDirectory;

  menu = pkgs.writeShellScriptBin "menu" ''
    if pgrep wofi; then
    	pkill wofi
    else
    	wofi --show drun
    fi
  '';

  powermenu = pkgs.writeShellScriptBin "powermenu" ''
    if pgrep wlogout; then
    	pkill wlogout
    else
      ${pkgs.wlogout}/bin/wlogout
    fi
  '';

  wireguard-import = pkgs.writeShellScriptBin "wireguard-import" ''
    nmcli connection import type wireguard file "$1"
  '';

  vault = pkgs.writeShellScriptBin "vault" ''
    nvim $HOME/Nextcloud/obsidian
  '';

in { home.packages = with pkgs; [ menu wireguard-import powermenu vault ]; }
