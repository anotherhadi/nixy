{ pkgs, config, ... }:

let
  homedir = config.home.homeDirectory;
  default = "4000";

  night-shift-on = pkgs.writeShellScriptBin "night-shift-on" ''
    ${pkgs.hyprland}/bin/hyprctl dispatch exec "${pkgs.wlsunset}/bin/wlsunset -t ${default}"
    ${pkgs.libnotify}/bin/notify-send "󰖔 Night Shift Activated"
  '';
  night-shift-off = pkgs.writeShellScriptBin "night-shift-off" ''
    pkill wlsunset
    ${pkgs.libnotify}/bin/notify-send " Night Shift Deactivated"
  '';

in { home.packages = with pkgs; [ night-shift-on night-shift-off ]; }
