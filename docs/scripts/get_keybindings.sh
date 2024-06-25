#!/usr/bin/env bash

[[ -f "./home/system/hyprland/default.nix" ]] || (echo "File ./home/system/hyprland/default.nix not found" && exit 1)

config=$( cat "./home/system/hyprland/default.nix")

# get text between
#  bind = [
# and next ]

# Example:
# "$mod, E, exec, ${pkgs.xfce.thunar}/bin/thunar" # Description
# Steps:
# We should remove the ""
# $mod replace by Super key
# $shiftMod replace by "Super Shift"
# Concat with key
# Remove , exec, 
# Remove variables and /bin/ if present

# Create a markdown table with everything 