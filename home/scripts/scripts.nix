{ pkgs, config, ... }:

let
  homedir = config.home.homeDirectory;

  #wallpaper = pkgs.writeShellScriptBin "wallpaper" ''
  #      WALLPAPER_FOLDER="${homedir}/Nextcloud/wallpaper"
  #
  #       cd $WALLPAPER_FOLDER
  #
  #       choosed_wallpaper=$(fd . |
  #      	fzf \
  # 		    --preview='kitty icat --clear --transfer-mode=memory --stdin=no --place=''${FZF_PREVIEW_COLUMNS}x''${FZF_PREVIEW_LINES}@0x0 {}' \
  #   		--preview-window=bottom,border-top \
  #    		--border-label "Wallpaper" ) || exit 1
  #
  #       swww img $choosed_wallpaper
  #      cp $choosed_wallpaper $HOME/.config/wallpaper/default.png
  #'';

  menu = pkgs.writeShellScriptBin "menu" ''
    if pgrep wofi; then
    	pkill wofi
    else
    	wofi --show drun
    fi
  '';

  powermenu = pkgs.writeShellScriptBin "powermenu" ''
    ${pkgs.wlogout}/bin/wlogout
  '';

  wireguard-import = pkgs.writeShellScriptBin "wireguard-import" ''
    nmcli connection import type wireguard file "$0"
  '';

in { home.packages = with pkgs; [ menu wireguard-import powermenu ]; }
