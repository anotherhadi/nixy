# - ## System
#-
#- Usefull quick scripts
#-
#- - `lock` - Lock the screen. (hyprlock)
#- - `powermode-toggle` - Toggle between performance and balanced power mode. (powerprofilesctl)
{pkgs, ...}: let
  menu =
    pkgs.writeShellScriptBin "menu"
    # bash
    ''
      if pgrep wofi; then
      	pkill wofi
      else
      	wofi -p "Apps" --show drun
      fi
    '';
  powermenu =
    pkgs.writeShellScriptBin "powermenu"
    # bash
    ''
      if pgrep wofi >/dev/null; then
        pkill wofi
        exit 0
      fi

      declare -A actions=(
        ["󰌾 Lock"]="hyprlock"
        ["󰍃 Logout"]="hyprctl dispatch exit"
        [" Suspend"]="systemctl suspend"
        ["󰑐 Reboot"]="systemctl reboot"
        ["󰿅 Shutdown"]="systemctl poweroff"
      )

      selected_option=$(
        printf '%s\n' "''${!actions[@]}" | wofi -p "Powermenu" --dmenu
      )

      if [[ -n "$selected_option" ]]; then

        action_command=''${actions["''$selected_option"]}

        if [[ -n "$action_command" ]]; then
          eval "$action_command"
        fi
      fi
    '';

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
in {home.packages = [lock powermode-toggle menu powermenu];}
