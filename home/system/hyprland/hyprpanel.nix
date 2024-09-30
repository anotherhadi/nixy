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

          "menus.dashboard.shortcuts.left.shortcut1.icon": "",
          "menus.dashboard.shortcuts.left.shortcut1.command": "qutebrowser",
          "menus.dashboard.shortcuts.left.shortcut1.tooltip": "Qutebrowser",
          "menus.dashboard.shortcuts.left.shortcut2.icon": "󰅶",
          "menus.dashboard.shortcuts.left.shortcut2.command": "caffeine",
          "menus.dashboard.shortcuts.left.shortcut2.tooltip": "Caffeine",
          "menus.dashboard.shortcuts.left.shortcut3.icon": "󰖔",
          "menus.dashboard.shortcuts.left.shortcut3.command": "night-shift",
          "menus.dashboard.shortcuts.left.shortcut3.tooltip": "Night-shift",
          "menus.dashboard.shortcuts.left.shortcut4.icon": "",
          "menus.dashboard.shortcuts.left.shortcut4.command": "menu",
          "menus.dashboard.shortcuts.left.shortcut4.tooltip": "Search Apps",
          "menus.dashboard.shortcuts.right.shortcut1.icon": "",
          "menus.dashboard.shortcuts.right.shortcut1.command": "hyprpicker -a",
          "menus.dashboard.shortcuts.right.shortcut1.tooltip": "Color Picker",
          "menus.dashboard.shortcuts.right.shortcut3.icon": "󰄀",
          "menus.dashboard.shortcuts.right.shortcut3.command": "screenshot region swappy",
          "menus.dashboard.shortcuts.right.shortcut3.tooltip": "Screenshot",

          "menus.dashboard.directories.left.directory1.label": "󰉍 Downloads",
          "menus.dashboard.directories.left.directory1.command": "bash -c \"thunar $HOME/Downloads/\"",
          "menus.dashboard.directories.left.directory2.label": "󰉏 Pictures",
          "menus.dashboard.directories.left.directory2.command": "bash -c \"thunar $HOME/Pictures/\"",
          "menus.dashboard.directories.left.directory3.label": "󱧶 Documents",
          "menus.dashboard.directories.left.directory3.command": "bash -c \"thunar $HOME/Documents/\"",
          "menus.dashboard.directories.right.directory1.label": "󱂵 Home",
          "menus.dashboard.directories.right.directory1.command": "bash -c \"thunar $HOME/\"",
          "menus.dashboard.directories.right.directory2.label": "󰚝 Projects",
          "menus.dashboard.directories.right.directory2.command": "bash -c \"thunar $HOME/dev/\"",
          "menus.dashboard.directories.right.directory3.label": " Config",
          "menus.dashboard.directories.right.directory3.command": "bash -c \"thunar $HOME/.config/\"",

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
          "theme.bar.menus.menu.media.card.tint": 90,
          "bar.customModules.updates.pollingInterval": 1440000
        }
      '';
  };
}
