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

  night-shift = pkgs.writeShellScriptBin "night-shift" ''
    if pgrep wlsunset; then
      night-shift-off
    else
      night-shift-on
    fi
  '';

  night-shift-status = pkgs.writeShellScriptBin "night-shift-status" ''
    if [[ $(pgrep wlsunset) ]]; then
      echo "1"
    else
      echo "0"
    fi
  '';

  night-shift-status-icon =
    pkgs.writeShellScriptBin "night-shift-status-icon" ''
      if [[ $(pgrep wlsunset) ]]; then
        echo "󰖔"
      else
        echo "󰖕"
      fi
    '';
in {
  home.packages = [
    night-shift-on
    night-shift-off
    night-shift
    night-shift-status
    night-shift-status-icon
  ];
}
