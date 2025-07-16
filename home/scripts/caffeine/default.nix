# - ## Caffeine
#-
#- Caffeine is a simple script that toggles hypridle (disable suspend & screenlock).
#-
#- - `caffeine-status` - Check if hypridle is running. (0/1)
#- - `caffeine-status-icon` - Check if hypridle is running. (icon)
#- - `caffeine` - Toggle hypridle.
{pkgs, ...}: let
  caffeine-status = pkgs.writeShellScriptBin "caffeine-status" ''
    [[ $(pidof "hypridle") ]] && echo "0" || echo "1"
  '';

  caffeine-status-icon = pkgs.writeShellScriptBin "caffeine-status-icon" ''
    [[ $(pidof "hypridle") ]] && echo "󰾪" || echo "󰅶"
  '';

  caffeine = pkgs.writeShellScriptBin "caffeine" ''
    if [[ $(pidof "hypridle") ]]; then
      systemctl --user stop hypridle.service
      title="󰅶  Caffeine Activated"
      description="Caffeine is now active! Your screen will not turn off automatically."
    else
      systemctl --user start hypridle.service
      title="󰾪  Caffeine Deactivated"
      description="Caffeine is now deactivated! Your screen will turn off automatically."
    fi

    notif "caffeine" "$title" "$description"
  '';
in {home.packages = [caffeine-status caffeine caffeine-status-icon];}
