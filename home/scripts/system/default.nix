# - ## System
#-
#- Usefull quick scripts
#-
#- - `lock` - Lock the screen. (hyprlock)
#- - `powermode-toggle` - Toggle between performance and balanced power mode. (powerprofilesctl)
{pkgs, ...}: let
  lock =
    pkgs.writeShellScriptBin "lock"
    # bash
    ''
      ${pkgs.hyprlock}/bin/hyprlock
    '';

  powermode-toggle =
    pkgs.writeShellScriptBin "powermode-toggle"
    # bash
    ''
      current_profile=$(powerprofilesctl get)
      if [ "$current_profile" = "performance" ]; then
        powerprofilesctl set balanced
        ${pkgs.swayosd}/bin/swayosd-client --custom-message="Powermode set to balanced" --custom-icon="emblem-default"
      else
        powerprofilesctl set performance
        ${pkgs.swayosd}/bin/swayosd-client --custom-message="Powermode set to performance" --custom-icon="emblem-default"
      fi
    '';
in {home.packages = [lock powermode-toggle];}
