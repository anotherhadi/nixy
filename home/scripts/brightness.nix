{ pkgs, config, ... }:

let
  homedir = config.home.homeDirectory;
  increments = "5";

  brightness-change = pkgs.writeShellScriptBin "brightness-change" ''
    sleep 0.05

    [[ $1 == "up" ]] && ${pkgs.brightnessctl}/bin/brightnessctl set ${increments}%+
    [[ $1 == "down" ]] && ${pkgs.brightnessctl}/bin/brightnessctl set ${increments}%-

    brightness_level=$(${pkgs.brightnessctl}/bin/brightnessctl get)

    message="󰃠  Brightness: $brightness_level%"

    ${pkgs.libnotify}/bin/notify-send "$message" \
                -h int:value:"$brightness_level" \
                --replace-id="$(cat "/tmp/nixy-notification" 2>/dev/null || echo 0)" --print-id > "/tmp/nixy-notification"
  '';

  brightness-up = pkgs.writeShellScriptBin "brightness-up" ''
    brightness-change up ${increments}
  '';

  brightness-down = pkgs.writeShellScriptBin "brightness-down" ''
    brightness-change down ${increments}
  '';

in {
  home.packages = with pkgs; [
    brightness-change
    brightness-up
    brightness-down
  ];
}
