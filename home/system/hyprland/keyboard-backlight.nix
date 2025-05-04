# Turn the keyboard red/off when the battery is low
{ pkgs, config, ... }:
let
  keyboard-backlight = pkgs.writeShellScriptBin "keyboard-backlight" ''
    function set_keyboard_backlight {
      local color=$1
        echo $color > /sys/devices/platform/hp-wmi/rgb_zones/zone00
        echo $color > /sys/devices/platform/hp-wmi/rgb_zones/zone01
        echo $color > /sys/devices/platform/hp-wmi/rgb_zones/zone02
        echo $color > /sys/devices/platform/hp-wmi/rgb_zones/zone03
    }
    state="white"
    set_keyboard_backlight ${config.lib.stylix.colors.base0D}
    while true; do
      BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT*/capacity)
      if [[ $BATTERY_LEVEL -le 10 ]]; then
        if [[ $state == "red" ]];then
          state="white"
          set_keyboard_backlight "000000"
        else
          state="red"
          set_keyboard_backlight "FF0000"
        fi
      else
        state="white"
        set_keyboard_backlight ${config.lib.stylix.colors.base0D}
      fi
      sleep 2
    done
  '';

  command = "bash ${keyboard-backlight}/bin/keyboard-backlight &";
in { wayland.windowManager.hyprland.settings.exec-once = [ command ]; }
