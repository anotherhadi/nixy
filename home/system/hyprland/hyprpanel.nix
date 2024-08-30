{ pkgs, config, ... }: {
  wayland.windowManager.hyprland.settings.exec-once =
    [ "${pkgs.hyprpanel}/bin/hyprpanel" ];

  home.packages = with pkgs; [ hyprpanel libnotify ];

  home.file.".cache/ags/hyprpanel/options.json" = {
    text = # json
      ''
        {
          "bar.layouts": {
            "0": {
              "left": [
                "dashboard",
                "workspaces",
                "windowtitle"
              ],
              "middle": [
                "media"
              ],
              "right": [
                "systray",
                "network",
                "volume",
                "bluetooth",
                "battery",
                "clock",
                "notifications"
              ]
            },
            "1": {
              "left": [
                "dashboard",
                "workspaces",
                "windowtitle"
              ],
              "middle": [
                "media"
              ],
              "right": [
                "systray",
                "network",
                "volume",
                "bluetooth",
                "battery",
                "clock",
                "notifications"
              ]
            },
            "2": {
              "left": [
                "dashboard",
                "workspaces",
                "windowtitle"
              ],
              "middle": [
                "media"
              ],
              "right": [
                "systray",
                "network",
                "volume",
                "bluetooth",
                "battery",
                "clock",
                "notifications"
              ]
            }
          },
          "theme.font.name": "${config.var.theme.font}",
          "theme.font.size": "${toString config.var.theme.bar.font-size}px",
          "theme.bar.outer_spacing": "${
            if config.var.theme.bar.floating
            && config.var.theme.bar.transparent then
              "0"
            else
              "8"
          }px",
          "theme.bar.buttons.y_margins": "${
            if config.var.theme.bar.floating
            && config.var.theme.bar.transparent then
              "0"
            else
              "8"
          }px",
          "theme.bar.buttons.spacing": "0.3em",
          "theme.bar.buttons.radius": "${
            if config.var.theme.bar.transparent then
              toString config.var.theme.rounding
            else
              toString (config.var.theme.rounding - 8)
          }px",
          "theme.bar.floating": ${
            if config.var.theme.bar.floating then "true" else "false"
          },
          "theme.bar.buttons.padding_x": "0.8rem",
          "theme.bar.buttons.padding_y": "0.4rem",

          "theme.bar.buttons.workspaces.hover": "#${config.var.theme.colors.accentalt}",
          "theme.bar.buttons.workspaces.active": "#${config.var.theme.colors.accent}",
          "theme.bar.buttons.workspaces.available": "#${config.var.theme.colors.bg}",

          "theme.bar.margin_top": "1.0em",
          "theme.bar.margin_sides": "${toString config.var.theme.gaps-out}px",
          "theme.bar.margin_bottom": "0px",
          "theme.bar.border_radius": "${toString config.var.theme.rounding}px",

          "bar.launcher.icon": "",
          "theme.bar.transparent": ${
            if config.var.theme.bar.transparent then "true" else "false"
          },
          "bar.workspaces.show_numbered": false,
          "bar.workspaces.workspaces": 5,
          "bar.workspaces.monitorSpecific": true,
          "bar.workspaces.hideUnoccupied": false,
          "bar.windowtitle.label": true,
          "bar.volume.label": false,
          "bar.network.truncation_size": 7,
          "bar.bluetooth.label": false,
          "bar.clock.format": "%a %b %d  %I:%M %p",
          "bar.notifications.show_total": true,
          "theme.notification.border_radius": "${
            toString config.var.theme.rounding
          }px",
          "theme.osd.enable": true,
          "theme.osd.orientation": "vertical",
          "theme.osd.location": "left",
          "theme.osd.radius": "${toString config.var.theme.rounding}px",
          "theme.osd.margins": "0px 0px 0px 10px",
          "theme.osd.muted_zero": true,
          "menus.clock.weather.location": "${config.var.location}",
          "menus.clock.weather.key": "myapikey",
          "menus.clock.weather.unit": "metric",
          "menus.dashboard.powermenu.avatar.image": "${config.var.homeDirectory}/.profile_picture.png",
          "menus.dashboard.powermenu.confirmation": false,
          "menus.dashboard.shortcuts": {
            "left": {
              "shortcut1": {
                "icon": "",
                "command": "qutebrowser",
                "tooltip": "Qutebrowser"
              },
              "shortcut2": {
                "icon": "",
                "command": "spotify",
                "tooltip": "Spotify"
              },
              "shortcut3": {
                "icon": "",
                "command": "discord",
                "tooltip": "Discord"
              },
              "shortcut4": {
                "icon": "",
                "command": "rofi -show drun",
                "tooltip": "Search Apps"
              }
            },
            "right": {
              "shortcut1": {
                "icon": "",
                "command": "hyprpicker -a",
                "tooltip": "Color Picker"
              },
              "shortcut3": {
                "icon": "󰄀",
                "command": "bash -c \"$HOME/.config/ags/services/snapshot.sh\"",
                "tooltip": "Screenshot"
              }
            }
          },
          "menus.dashboard.directories": {
            "left": {
              "directory1": {
                "label": "󰉍 Downloads",
                "command": "bash -c \"dolphin $HOME/Downloads/\""
              },
              "directory2": {
                "label": "󰉏 Videos",
                "command": "bash -c \"dolphin $HOME/Videos/\""
              },
              "directory3": {
                "label": "󰚝 Projects",
                "command": "bash -c \"dolphin $HOME/Projects/\""
              }
            },
            "right": {
              "directory1": {
                "label": "󱧶 Documents",
                "command": "bash -c \"dolphin $HOME/Documents/\""
              },
              "directory2": {
                "label": "󰉏 Pictures",
                "command": "bash -c \"dolphin $HOME/Pictures/\""
              },
              "directory3": {
                "label": "󱂵 Home",
                "command": "bash -c \"dolphin $HOME/\""
              }
            }
          },

          "theme.bar.menus.monochrome": true,
          "wallpaper.enable": false,
          "theme.bar.menus.background": "#${config.var.theme.colors.bg}",
          "theme.bar.menus.cards": "#${config.var.theme.colors.bgalt}",
          "theme.bar.menus.card_radius": "${
            toString config.var.theme.rounding
          }px",
          "theme.bar.menus.label": "#${config.var.theme.colors.fg}",
          "theme.bar.menus.text": "#${config.var.theme.colors.fg}",
          "theme.bar.menus.border.size": "${
            toString config.var.theme.border-size
          }px",
          "theme.bar.menus.border.color": "#${config.var.theme.colors.accent}",
          "theme.bar.menus.border.radius": "${
            toString config.var.theme.rounding
          }px",
          "theme.bar.menus.popover.text": "#${config.var.theme.colors.fg}",
          "theme.bar.menus.popover.background": "#${config.var.theme.colors.bgalt}",
          "theme.bar.menus.listitems.active": "#${config.var.theme.colors.accent}",
          "theme.bar.menus.icons.active": "#${config.var.theme.colors.accent}",
          "theme.bar.menus.switch.enabled": "#${config.var.theme.colors.accent}",
          "theme.bar.menus.check_radio_button.active": "#${config.var.theme.colors.accent}",
          "theme.bar.menus.buttons.default": "#${config.var.theme.colors.accent}",
          "theme.bar.menus.buttons.active": "#${config.var.theme.colors.accent}",
          "theme.bar.menus.iconbuttons.active": "#${config.var.theme.colors.accent}",
          "theme.bar.menus.progressbar.foreground": "#${config.var.theme.colors.accent}",
          "theme.bar.menus.slider.primary": "#${config.var.theme.colors.accent}",
          "theme.bar.menus.tooltip.background": "#${config.var.theme.colors.bgalt}",
          "theme.bar.menus.tooltip.text": "#${config.var.theme.colors.fg}",
          "theme.bar.menus.dropdownmenu.background": "#${config.var.theme.colors.bgalt}",
          "theme.bar.menus.dropdownmenu.text": "#${config.var.theme.colors.fg}",
          "theme.bar.background": "#${config.var.theme.colors.bg}",
          "theme.bar.buttons.style": "default",
          "theme.bar.buttons.monochrome": true,
          "theme.bar.buttons.text": "#${config.var.theme.colors.fg}",
          "theme.bar.buttons.background": "#${config.var.theme.colors.bgalt}",
          "theme.bar.buttons.icon": "#${config.var.theme.colors.accent}",
          "theme.bar.buttons.notifications.background": "#${config.var.theme.colors.bgalt}",
          "theme.bar.buttons.hover": "#${config.var.theme.colors.bg}",
          "theme.bar.buttons.notifications.hover": "#${config.var.theme.colors.bg}",
          "theme.bar.buttons.notifications.total": "#${config.var.theme.colors.accent}",
          "theme.bar.buttons.notifications.icon": "#${config.var.theme.colors.accent}",
          "theme.notification.background": "#${config.var.theme.colors.bgalt}",
          "theme.notification.actions.background": "#${config.var.theme.colors.accent}",
          "theme.notification.actions.text": "#${config.var.theme.colors.fg}",
          "theme.notification.label": "#${config.var.theme.colors.accent}",
          "theme.notification.border": "#${config.var.theme.colors.bgalt}",
          "theme.notification.text": "#${config.var.theme.colors.fgalt}",
          "theme.notification.labelicon": "#${config.var.theme.colors.accent}",
          "theme.osd.bar_color": "#${config.var.theme.colors.accent}",
          "theme.osd.bar_overflow_color": "#${config.var.theme.colors.accentalt}",
          "theme.osd.icon": "#${config.var.theme.colors.bg}",
          "theme.osd.icon_container": "#${config.var.theme.colors.accent}",
          "theme.osd.label": "#${config.var.theme.colors.accent}",
          "theme.osd.bar_container": "#${config.var.theme.colors.bgalt}",
          "theme.bar.menus.menu.media.background.color": "#${config.var.theme.colors.bgalt}",
          "theme.bar.menus.menu.media.card.color": "#${config.var.theme.colors.bgalt}",
          "theme.bar.menus.menu.media.card.tint": 90
        }
      '';
  };
}
