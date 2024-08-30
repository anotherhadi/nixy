{ pkgs, ... }:

let
  increments = "5";

  sound-change = pkgs.writeShellScriptBin "sound-change" ''
    [[ $1 == "mute" ]] && wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    [[ $1 == "up" ]] && wpctl set-volume @DEFAULT_AUDIO_SINK@ ''${2-${increments}}%+
    [[ $1 == "down" ]] && wpctl set-volume @DEFAULT_AUDIO_SINK@ ''${2-${increments}}%-
    [[ $1 == "set" ]] && wpctl set-volume @DEFAULT_AUDIO_SINK@ ''${2-100}%
  '';

  sound-up = pkgs.writeShellScriptBin "sound-up" ''
    sound-change up ${increments}
  '';

  sound-set = pkgs.writeShellScriptBin "sound-set" ''
    sound-change set ''${1-100}
  '';

  sound-down = pkgs.writeShellScriptBin "sound-down" ''
    sound-change down ${increments}
  '';

  sound-toggle = pkgs.writeShellScriptBin "sound-toggle" ''
    sound-change mute
  '';
in {
  home.packages = [ sound-change sound-up sound-down sound-toggle sound-set ];
}
