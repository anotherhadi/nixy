# - ## Screenshot
#-
#- This module provides a script to take screenshots using `grimblast` and `swappy`.
#-
#- - `screenshot [region|window|monitor] [swappy]` - Take a screenshot of the region, window, or monitor. Optionally, use `swappy` to copy the screenshot to the clipboard.
{pkgs, ...}: let
  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    if [[ $2 == "swappy" ]];then
      folder="/tmp"
    else
      folder="$HOME/Pictures"
    fi
    filename="$(date +%Y-%m-%d_%H:%M:%S).png"

    if [[ $1 == "window" ]];then
      mode="active"
    elif [[ $1 == "region" ]];then
      mode="area"
    elif [[ $1 == "monitor" ]];then
      mode="output"
    fi

    ${pkgs.grimblast}/bin/grimblast --notify --freeze copysave $mode "$folder/$filename" || exit 1

    if [[ $2 == "swappy" ]];then
      ${pkgs.swappy}/bin/swappy -f "$folder/$filename" -o "$HOME/Pictures/$filename"
      exit 0
    fi
  '';
in {
  home.packages = [ screenshot pkgs.grim pkgs.grimblast ];
}
