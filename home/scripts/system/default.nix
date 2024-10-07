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
    hyprpanel -t powerdropdownmenu
  '';

  lock = pkgs.writeShellScriptBin "lock" ''
    ${pkgs.hyprlock}/bin/hyprlock
  '';

in { home.packages = [ menu powermenu lock ]; }
