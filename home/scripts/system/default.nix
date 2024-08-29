{ pkgs, ... }:

let
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

  lock = pkgs.writeShellScriptBin "lock" ''
    ${pkgs.hyprlock}/bin/hyprlock
  '';

in { home.packages = [ menu powermenu lock ]; }
