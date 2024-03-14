{ pkgs, config, ... }:
let
  homedir = config.home.homeDirectory;

  caffeine-status = pkgs.writeShellScriptBin "caffeine-status" ''
    [[ -f /tmp/caffeine ]] && echo "active" || echo "inactive"
  '';

  caffeine = pkgs.writeShellScriptBin "caffeine" ''
    if [[ -f /tmp/caffeine ]]; then
      rm /tmp/caffeine
      ${pkgs.hyprland}/bin/hyprctl dispatch exec ${pkgs.hypridle}/bin/hypridle
      ${pkgs.libnotify}/bin/notify-send "󰾪 Caffeine Deactivated"
    else
      touch /tmp/caffeine
      pkill hypridle && ${pkgs.libnotify}/bin/notify-send "󰅶 Caffeine Activated"
    fi
  '';

in { home.packages = with pkgs; [ caffeine-status caffeine ]; }
