{ pkgs, ... }:

let
  increments = "5";

  sound-change = pkgs.writeShellScriptBin "sound-change" ''
    sleep 0.05

    [[ $1 == "mute" ]] && wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    [[ $1 == "up" ]] && wpctl set-volume @DEFAULT_AUDIO_SINK@ "$2%+"
    [[ $1 == "down" ]] && wpctl set-volume @DEFAULT_AUDIO_SINK@ "$2%-"
  '';

  sound-up = pkgs.writeShellScriptBin "sound-up" ''
    sound-change up ${increments}
  '';

  sound-down = pkgs.writeShellScriptBin "sound-down" ''
    sound-change down ${increments}
  '';

  sound-toggle = pkgs.writeShellScriptBin "sound-toggle" ''
    sound-change mute
  '';
in { home.packages = [ sound-change sound-up sound-down sound-toggle ]; }
