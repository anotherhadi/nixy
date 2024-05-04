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
      message="󰾪  Caffeine Deactivated"
    else
      touch /tmp/caffeine
      pkill hypridle
      message="󰅶  Caffeine Activated"
    fi
    ${pkgs.libnotify}/bin/notify-send "$message" \
      --replace-id="$(cat "/tmp/nixy-notification" 2>/dev/null || echo 0)" --print-id > "/tmp/nixy-notification"
  '';

in { home.packages = with pkgs; [ caffeine-status caffeine ]; }
