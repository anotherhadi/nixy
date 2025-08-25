# - ## System
#-
#- Usefull quick scripts
#-
#- - `menu` - Open wofi with drun mode. (wofi)
#- - `powermenu` - Open power dropdown menu. (wofi)
#- - `quickmenu` - Open a dropdown menu with shortcuts and scripts. (wofi)
#- - `lock` - Lock the screen. (hyprlock)
{pkgs, ...}: let
  menu =
    pkgs.writeShellScriptBin "menu"
    # bash
    ''
      if pgrep wofi; then
      	pkill wofi
      else
      	wofi -p " Apps" --show drun &
      	# # Quit when not focused anymore
      	# sleep 0.2
      	# while true; do
      	# 	window=$(hyprctl activewindow | grep "wofi")
      	# 	if [[ ! $window ]]; then
      	# 		pkill wofi
      	# 		break
      	# 	fi
      	# 	sleep 0.2
      	# done
      fi
    '';

  powermenu =
    pkgs.writeShellScriptBin "powermenu"
    # bash
    ''
      if pgrep wofi; then
      	pkill wofi
      # if pgrep tofi; then
      #   pkill tofi
      else
        options=(
          "󰌾 Lock"
          "󰍃 Logout"
          " Suspend"
          "󰑐 Reboot"
          "󰿅 Shutdown"
        )

        selected=$(printf '%s\n' "''${options[@]}" | wofi -p " Powermenu" --dmenu)
        # selected=$(printf '%s\n' "''${options[@]}" | tofi --prompt-text "> ")
        selected=''${selected:2}

        case $selected in
          "Lock")
            ${pkgs.hyprlock}/bin/hyprlock
            ;;
          "Logout")
            hyprctl dispatch exit
            ;;
          "Suspend")
            systemctl suspend
            ;;
          "Reboot")
            systemctl reboot
            ;;
          "Shutdown")
            systemctl poweroff
            ;;
        esac
      fi
    '';

  quickmenu =
    pkgs.writeShellScriptBin "quickmenu"
    # bash
    ''
      if pgrep wofi; then
      	pkill wofi
      # if pgrep tofi; then
      #   pkill tofi
      else
        options=(
          "󰖔 Night-shift"
          " Nixy"
          "󰈊 Hyprpicker"
          "󰖂 Toggle VPN"
        )

        selected=$(printf '%s\n' "''${options[@]}" | wofi -p " Quickmenu" --dmenu)
        # selected=$(printf '%s\n' "''${options[@]}" | tofi --prompt-text "> ")
        selected=''${selected:2}

        case $selected in
          "Night-shift")
            night-shift
            ;;
          "Nixy")
            kitty zsh -c nixy
            ;;
          "Hyprpicker")
            sleep 0.2 && ${pkgs.hyprpicker}/bin/hyprpicker -a
            ;;
          "Toggle VPN")
            openvpn-toggle
            ;;
        esac
      fi
    '';

  lock =
    pkgs.writeShellScriptBin "lock"
    # bash
    ''
      ${pkgs.hyprlock}/bin/hyprlock
    '';
in {home.packages = [menu powermenu lock quickmenu];}
