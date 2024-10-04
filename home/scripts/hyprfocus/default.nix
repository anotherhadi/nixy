{ pkgs, ... }:
let
  hyprfocus-on = pkgs.writeShellScriptBin "hyprfocus-on"
    # bash
    ''
      hyprctl keyword "general:gaps_in" 0
      hyprctl keyword "general:gaps_out" 0
      # TODO: Fix this:
      hyprpanel-toggle
      hyprctl keyword "general:border_size" 1
      hyprctl keyword "decoration:rounding" 0
      hyprctl keyword "decoration:drop_shadow" false
      hyprctl keyword "decoration:inactive_opacity" 0.98
      hyprctl keyword "decoration:active_opacity" 1
      echo "1" > /tmp/hyprfocus
    '';

  hyprfocus-off = pkgs.writeShellScriptBin "hyprfocus-off"
    # bash
    ''
      hyprctl reload
      hyprpanel-reload
      rm /tmp/hyprfocus
    '';

  hyprfocus-toggle = pkgs.writeShellScriptBin "hyprfocus-toggle"
    # bash 
    ''
      if [ -f /tmp/hyprfocus ]; then
        hyprfocus-kill
      else
        hyprfocus
      fi
    '';
in { home.packages = [ hyprfocus-on hyprfocus-off hyprfocus-toggle ]; }
