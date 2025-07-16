# - ## Brightness
#-
#- This module provides a set of scripts to control the brightness of the screen.
#-
#- - `brightness-up` increases the brightness by 5%.
#- - `brightness-down` decreases the brightness by 5%.
#- - `brightness-set [value]` sets the brightness to the given value.
#- - `brightness-change [up|down] [value]` increases or decreases the brightness by the given value.
{pkgs, ...}: let
  increments = "5";

  brightness-change = pkgs.writeShellScriptBin "brightness-change" ''
    [[ $1 == "up" ]] && ${pkgs.brightnessctl}/bin/brightnessctl set ''${2-${increments}}%+
    [[ $1 == "down" ]] && ${pkgs.brightnessctl}/bin/brightnessctl set ''${2-${increments}}%-
  '';

  brightness-set = pkgs.writeShellScriptBin "brightness-set" ''
    ${pkgs.brightnessctl}/bin/brightnessctl set ''${1-100}%
  '';

  brightness-up = pkgs.writeShellScriptBin "brightness-up" ''
    brightness-change up ${increments}
  '';

  brightness-down = pkgs.writeShellScriptBin "brightness-down" ''
    brightness-change down ${increments}
  '';
in {
  home.packages = [
    pkgs.brightnessctl
    brightness-change
    brightness-up
    brightness-down
    brightness-set
  ];
}
