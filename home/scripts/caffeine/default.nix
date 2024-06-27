{ pkgs, ... }:
let
  caffeine-status = pkgs.writeShellScriptBin "caffeine-status" ''
    [[ -f /tmp/caffeine ]] && echo "active" || echo "inactive"
  '';

  caffeine = pkgs.writeShellScriptBin "caffeine" ''
    if [[ -f /tmp/caffeine ]]; then
      rm /tmp/caffeine
      ${pkgs.hyprland}/bin/hyprctl dispatch exec ${pkgs.hypridle}/bin/hypridle
      message="󰾪  Caffeine Deactivated"
    else
      touch /tmp/caffeine
      pkill hypridle
      message="󰅶  Caffeine Activated"
    fi
    notif "caffeine" "$message"
  '';

  caffeine-status-icon = pkgs.writeShellScriptBin "caffeine-status-icon" ''
    status=$(caffeine-status)
    if [[ $status == "active" ]]; then
      echo "󰅶"
    else
      echo "󰾪"
    fi
  '';

in { home.packages = [ caffeine-status caffeine caffeine-status-icon ]; }
