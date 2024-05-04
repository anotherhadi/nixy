{ pkgs, config, ... }:

let
  homedir = config.home.homeDirectory;
  default = "4000";

  night-shift-on = pkgs.writeShellScriptBin "night-shift-on" ''
    ${pkgs.hyprland}/bin/hyprctl dispatch exec "${pkgs.wlsunset}/bin/wlsunset -t ${default}"
    message="󰖔  Night-Shift Activated"
    ${pkgs.libnotify}/bin/notify-send "$message" \
      --replace-id="$(cat "/tmp/nixy-notification" 2>/dev/null || echo 0)" --print-id > "/tmp/nixy-notification"
  '';
  night-shift-off = pkgs.writeShellScriptBin "night-shift-off" ''
    pkill wlsunset
    message="󰖔  Night-Shift Deactivated"
    ${pkgs.libnotify}/bin/notify-send "$message" \
      --replace-id="$(cat "/tmp/nixy-notification" 2>/dev/null || echo 0)" --print-id > "/tmp/nixy-notification"
  '';

in { home.packages = with pkgs; [ night-shift-on night-shift-off ]; }
