# - ## Hyprpanel
#- 
#- Quick scripts to toggle, reload and kill hyprpanel.
#-
#- - `hyprpanel-toggle` - Toggle hyprpanel.
#- - `hyprpanel-reload` - Reload hyprpanel.
#- - `hyprpanel-kill` - Kill hyprpanel.
{ pkgs, ... }:
let
  hyprpanel-toggle = pkgs.writeShellScriptBin "hyprpanel-toggle" ''
    hyprpanel -t bar-0
    hyprpanel -t bar-1
    hyprpanel -t bar-2
    hyprpanel -t bar-3
  '';

  hyprpanel-reload = pkgs.writeShellScriptBin "hyprpanel-reload" ''
    [ $(pgrep "ags") ] && pkill ags
    hyprctl dispatch exec hyprpanel
  '';

  hyprpanel-kill = pkgs.writeShellScriptBin "hyprpanel-kill" ''
    [ $(pgrep "ags") ] && pkill ags
  '';
in { home.packages = [ hyprpanel-toggle hyprpanel-reload hyprpanel-kill ]; }
