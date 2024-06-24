{ pkgs, ... }:

let
  default = "4000";

  night-shift-on = pkgs.writeShellScriptBin "night-shift-on" ''
    ${pkgs.hyprland}/bin/hyprctl dispatch exec "${pkgs.wlsunset}/bin/wlsunset -t ${default}"
    message="󰖔  Night-Shift Activated"
    notif "night-shift" "$message"
  '';

  night-shift-off = pkgs.writeShellScriptBin "night-shift-off" ''
    pkill wlsunset
    message="󰖔  Night-Shift Deactivated"
    notif "night-shift" "$message"
  '';

in { home.packages = [ night-shift-on night-shift-off ]; }
