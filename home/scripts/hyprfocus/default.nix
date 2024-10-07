# - ## Hyprfocus
#-
#- A simple script to toggle focus on few windows in Hyprland.
#- (disable gaps, border, shadow, opacity, etc.)
#-
#- - `hyprfocus-on` - Enable hyprfocus.
#- - `hyprfocus-off` - Disable hyprfocus.
#- - `hyprfocus-toggle` - Toggle hyprfocus.
{ pkgs, ... }:
let
  hyprfocus-on = pkgs.writeShellScriptBin "hyprfocus-on"
    # bash
    ''
      hyprctl keyword "general:gaps_in" 0
      hyprctl keyword "general:gaps_out" 0
      hyprpanel-hide
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
      hyprpanel-show
      rm /tmp/hyprfocus
    '';

  hyprfocus-toggle = pkgs.writeShellScriptBin "hyprfocus-toggle"
    # bash 
    ''
      if [ -f /tmp/hyprfocus ]; then
        hyprfocus-off
      else
        hyprfocus-on
      fi
    '';
in { home.packages = [ hyprfocus-on hyprfocus-off hyprfocus-toggle ]; }
