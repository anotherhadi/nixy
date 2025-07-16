# - ## Night-Shift
#-
#- Night-Shift is a feature that reduces the amount of blue light emitted by your screen, which can help reduce eye strain and improve sleep quality. This module provides a set of scripts to control Night-Shift on your system.
#- It use hyprsunset to control the screen temperature.
#-
#- - `night-shift-on` activates Night-Shift.
#- - `night-shift-off` deactivates Night-Shift.
#- - `night-shift` toggles Night-Shift.
#- - `night-shift-status` checks if Night-Shift is active. (0/1)
#- - `night-shift-status-icon` checks if Night-Shift is active. (icon)
{pkgs, ...}: let
  value = "4500"; # Default value for night-shift temperature

  night-shift-on =
    pkgs.writeShellScriptBin "night-shift-on"
    # bash
    ''
      ${pkgs.hyprsunset}/bin/hyprsunset -t ${value} &
      title="󰖔  Night-Shift Activated"
      description="Night-Shift is now activated! Your screen will be warmer and easier on the eyes."

      notif "night-shift" "$title" "$description"
    '';

  night-shift-off =
    pkgs.writeShellScriptBin "night-shift-off"
    # bash
    ''
      pkill hyprsunset
      title="󰖕  Night-Shift Deactivated"
      description="Night-Shift is now deactivated! Your screen will return to normal."

      notif "night-shift" "$title" "$description"
    '';

  night-shift =
    pkgs.writeShellScriptBin "night-shift"
    # bash
    ''
      if pidof "hyprsunset"; then
        night-shift-off
      else
        night-shift-on
      fi
    '';

  night-shift-status =
    pkgs.writeShellScriptBin "night-shift-status"
    # bash
    ''
      if pidof "hyprsunset"; then
        echo "1"
      else
        echo "0"
      fi
    '';

  night-shift-status-icon =
    pkgs.writeShellScriptBin "night-shift-status-icon"
    # bash
    ''
      if pidof "hyprsunset"; then
          echo "󰖔"
        else
          echo "󰖕"
        fi
    '';
in {
  home.packages = [
    pkgs.hyprsunset
    night-shift-on
    night-shift-off
    night-shift
    night-shift-status
    night-shift-status-icon
  ];
}
