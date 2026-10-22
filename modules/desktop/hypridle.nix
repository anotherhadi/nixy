# hypridle handles idle management: lock the screen, turn the display off, and
# suspend after periods of inactivity. The `caffeine-toggle` script pauses it.
{config, ...}: let
  inherit (config.flake.lib) toHyprconf;
in {
  flake.modules.nixos.desktop = {
    services.hypridle.enable = true; # user unit, started with graphical-session.target

    hjem.extraModules = [
      ({
        pkgs,
        scripts,
        ...
      }: {
        # Screen on/off for Hyprland or sway
        scripts.dpms = pkgs.writeShellScriptBin "dpms" ''
          if [ -n "$SWAYSOCK" ]; then
            ${pkgs.sway}/bin/swaymsg "output * power $1"
          else
            ${pkgs.hyprland}/bin/hyprctl dispatch dpms "$1"
          fi
        '';

        scripts.caffeine-toggle = pkgs.writeShellScriptBin "caffeine-toggle" ''
          # Pause hypridle (stay awake) or resume it.
          if systemctl --user is-active --quiet hypridle; then
            systemctl --user stop hypridle
            OSD_TEXT="󰅶  Keep Awake On"
          else
            systemctl --user start hypridle
            OSD_TEXT="󰾫  Keep Awake Off"
          fi
          ${scripts.waybar-osd}/bin/waybar-osd "$OSD_TEXT" caffeine
        '';

        packages = [
          scripts.caffeine-toggle
          (pkgs.makeDesktopItem {
            name = "caffeine-toggle";
            desktopName = "Keep Awake";
            exec = "${scripts.caffeine-toggle}/bin/caffeine-toggle";
            icon = "my-caffeine-on-symbolic";
            comment = "Pause or resume idle locking and suspend";
            categories = ["System"];
            terminal = false;
            keywords = ["caffeine" "idle" "awake" "inhibit" "suspend"];
          })
        ];

        xdg.config.files."hypr/hypridle.conf".text = toHyprconf {
          attrs = {
            general = {
              # Avoid starting multiple hyprlock instances.
              lock_cmd = "${pkgs.procps}/bin/pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock --grace 5";
              before_sleep_cmd = "loginctl lock-session";
              after_sleep_cmd = "${scripts.dpms}/bin/dpms on";
            };

            listener = [
              {
                timeout = 300; # 5 min → lock
                on-timeout = "loginctl lock-session";
              }
              {
                timeout = 720; # 12 min → screen off
                on-timeout = "${scripts.dpms}/bin/dpms off";
                on-resume = "${scripts.dpms}/bin/dpms on";
              }
              {
                timeout = 1800; # 30 min → suspend
                on-timeout = "systemctl suspend";
              }
            ];
          };
        };
      })
    ];
  };
}
