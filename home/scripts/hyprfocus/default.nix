{ pkgs, ... }:
let
  hyprfocus = pkgs.writeShellScriptBin "hyprfocus" ''
    hyprctl keyword "general:gaps_in" 0
    hyprctl keyword "general:gaps_out" 0
    # TODO: Fix this:
    hyprpanel-toggle
    hyprctl keyword "general:border_size" 1
    hyprctl keyword "decoration:rounding" 0
    hyprctl keyword "decoration:drop_shadow" false
    hyprctl keyword "decoration:inactive_opacity" 0.98
    hyprctl keyword "decoration:active_opacity" 1
  '';

  hyprfocus-kill = pkgs.writeShellScriptBin "hyprfocus-kill" ''
    hyprctl reload
    hyprpanel-reload
  '';
in { home.packages = [ hyprfocus hyprfocus-kill ]; }
