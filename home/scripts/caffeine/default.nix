{ pkgs, ... }:
let
  caffeine-status = pkgs.writeShellScriptBin "caffeine-status" ''
    [[ $(pidof "hypridle") ]] && echo "0" || echo "1"
  '';

  caffeine-status-icon = pkgs.writeShellScriptBin "caffeine-status-icon" ''
    [[ $(pidof "hypridle") ]] && echo "󰾪" || echo "󰅶"
  '';

  caffeine = pkgs.writeShellScriptBin "caffeine" ''
    if [[ $(pidof "hypridle") ]]; then
      pkill hypridle
      title="󰅶  Caffeine Activated"
      description="Caffeine is now active! Your screen will not turn off automatically."
    else
      ${pkgs.hyprland}/bin/hyprctl dispatch exec ${pkgs.hypridle}/bin/hypridle
      title="󰾪  Caffeine Deactivated"
      description="Caffeine is now deactivated! Your screen will turn off automatically."
    fi

    notif "caffeine" "$title" "$description"
  '';

in { home.packages = [ caffeine-status caffeine caffeine-status-icon ]; }
