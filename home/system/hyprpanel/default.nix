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
          "theme.font.name": "${config.stylix.fonts.serif.name}",
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

          "theme.bar.buttons.workspaces.hover": "#${config.lib.stylix.colors.base0A}",
          "theme.bar.buttons.workspaces.active": "#${config.lib.stylix.colors.base0D}",
          "theme.bar.buttons.workspaces.available": "#${config.lib.stylix.colors.base00}",

          "theme.bar.margin_top": "${
            toString (config.var.theme.gaps-in * 2)
          }px",
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
          "bar.network.truncation_size": 12,
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
          "menus.dashboard.powermenu.avatar.image": "/home/${config.var.username}/.profile_picture.png",
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
          "theme.bar.menus.background": "#${config.lib.stylix.colors.base00}",
          "theme.bar.menus.cards": "#${config.lib.stylix.colors.base01}",
          "theme.bar.menus.card_radius": "${
            toString config.var.theme.rounding
          }px",
          "theme.bar.menus.label": "#${config.lib.stylix.colors.base05}",
          "theme.bar.menus.text": "#${config.lib.stylix.colors.base05}",
          "theme.bar.menus.border.size": "${
            toString config.var.theme.border-size
          }px",
          "theme.bar.menus.border.color": "#${config.lib.stylix.colors.base0D}",
          "theme.bar.menus.border.radius": "${
            toString config.var.theme.rounding
          }px",
          "theme.bar.menus.popover.text": "#${config.lib.stylix.colors.base05}",
          "theme.bar.menus.popover.background": "#${config.lib.stylix.colors.base01}",
          "theme.bar.menus.listitems.active": "#${config.lib.stylix.colors.base0D}",
          "theme.bar.menus.icons.active": "#${config.lib.stylix.colors.base0D}",
          "theme.bar.menus.switch.enabled": "#${config.lib.stylix.colors.base0D}",
          "theme.bar.menus.check_radio_button.active": "#${config.lib.stylix.colors.base0D}",
          "theme.bar.menus.buttons.default": "#${config.lib.stylix.colors.base0D}",
          "theme.bar.menus.buttons.active": "#${config.lib.stylix.colors.base0D}",
          "theme.bar.menus.iconbuttons.active": "#${config.lib.stylix.colors.base0D}",
          "theme.bar.menus.progressbar.foreground": "#${config.lib.stylix.colors.base0D}",
          "theme.bar.menus.slider.primary": "#${config.lib.stylix.colors.base0D}",
          "theme.bar.menus.tooltip.background": "#${config.lib.stylix.colors.base01}",
          "theme.bar.menus.tooltip.text": "#${config.lib.stylix.colors.base05}",
          "theme.bar.menus.dropdownmenu.background": "#${config.lib.stylix.colors.base01}",
          "theme.bar.menus.dropdownmenu.text": "#${config.lib.stylix.colors.base05}",
          "theme.bar.background": "#${config.lib.stylix.colors.base00}",
          "theme.bar.buttons.style": "default",
          "theme.bar.buttons.monochrome": true,
          "theme.bar.buttons.text": "#${config.lib.stylix.colors.base05}",
          "theme.bar.buttons.background": "#${config.lib.stylix.colors.base01}",
          "theme.bar.buttons.icon": "#${config.lib.stylix.colors.base0D}",
          "theme.bar.buttons.notifications.background": "#${config.lib.stylix.colors.base01}",
          "theme.bar.buttons.hover": "#${config.lib.stylix.colors.base00}",
          "theme.bar.buttons.notifications.hover": "#${config.lib.stylix.colors.base00}",
          "theme.bar.buttons.notifications.total": "#${config.lib.stylix.colors.base0D}",
          "theme.bar.buttons.notifications.icon": "#${config.lib.stylix.colors.base0D}",
          "theme.notification.background": "#${config.lib.stylix.colors.base01}",
          "theme.notification.actions.background": "#${config.lib.stylix.colors.base0D}",
          "theme.notification.actions.text": "#${config.lib.stylix.colors.base05}",
          "theme.notification.label": "#${config.lib.stylix.colors.base0D}",
          "theme.notification.border": "#${config.lib.stylix.colors.base01}",
          "theme.notification.text": "#${config.lib.stylix.colors.base05}",
          "theme.notification.labelicon": "#${config.lib.stylix.colors.base0D}",
          "theme.osd.bar_color": "#${config.lib.stylix.colors.base0D}",
          "theme.osd.bar_overflow_color": "#${config.lib.stylix.colors.base0A}",
          "theme.osd.icon": "#${config.lib.stylix.colors.base00}",
          "theme.osd.icon_container": "#${config.lib.stylix.colors.base0D}",
          "theme.osd.label": "#${config.lib.stylix.colors.base0D}",
          "theme.osd.bar_container": "#${config.lib.stylix.colors.base01}",
          "theme.bar.menus.menu.media.background.color": "#${config.lib.stylix.colors.base01}",
          "theme.bar.menus.menu.media.card.color": "#${config.lib.stylix.colors.base01}",
          "theme.bar.menus.menu.media.card.tint": 90,
          "bar.customModules.updates.pollingInterval": 1440000,
          "bar.media.show_active_only": true
        }
      '';
  };
}
