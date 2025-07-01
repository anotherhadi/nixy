# Hyprpanel is the bar on top of the screen
# Display information like workspaces, battery, wifi, ...
{config, ...}: let
  transparentButtons = config.theme.bar.transparentButtons;

  accent = "#${config.lib.stylix.colors.base0D}";
  accent-alt = "#${config.lib.stylix.colors.base03}";
  background = "#${config.lib.stylix.colors.base00}";
  background-alt = "#${config.lib.stylix.colors.base01}";
  foreground = "#${config.lib.stylix.colors.base05}";
  foregroundOnWallpaper = "#${config.theme.textColorOnWallpaper}";
  font = "${config.stylix.fonts.serif.name}";
  fontSizeForHyprpanel = "${toString config.stylix.fonts.sizes.desktop}px";

  rounding = config.theme.rounding;
  border-size = config.theme.border-size;

  gaps-out = config.theme.gaps-out;
  gaps-in = config.theme.gaps-in;

  floating = config.theme.bar.floating;
  transparent = config.theme.bar.transparent;
  position = config.theme.bar.position; # "top" ou "bottom"

  notificationOpacity = 90;

  location = config.var.location;
in {
  wayland.windowManager.hyprland.settings.exec-once = ["hyprpanel"];

  programs.hyprpanel = {
    enable = true;

    settings = {
      layout = {
        bar.layouts = {
          "*" = {
            "left" = [
              "dashboard"
              "workspaces"
              "windowtitle"
            ];
            "middle" = [
              "media"
              "cava"
            ];
            "right" = [
              "systray"
              "volume"
              "bluetooth"
              "battery"
              "network"
              "clock"
              "notifications"
            ];
          };
        };
      };

      theme.font.name = font;
      theme.font.size = fontSizeForHyprpanel;

      theme.bar.outer_spacing =
        if floating && transparent
        then "0px"
        else "8px";
      theme.bar.buttons.y_margins =
        if floating && transparent
        then "0px"
        else "8px";
      theme.bar.buttons.spacing = "0.3em";
      theme.bar.buttons.radius =
        (
          if transparent
          then toString rounding
          else toString (rounding - 8)
        )
        + "px";
      theme.bar.floating = floating;
      theme.bar.buttons.padding_x = "0.8rem";
      theme.bar.buttons.padding_y = "0.4rem";

      theme.bar.margin_top =
        (
          if position == "top"
          then toString (gaps-in * 2)
          else "0"
        )
        + "px";
      theme.bar.margin_bottom =
        (
          if position == "top"
          then "0"
          else toString (gaps-in * 2)
        )
        + "px";
      theme.bar.margin_sides = toString gaps-out + "px";
      theme.bar.border_radius = toString rounding + "px";
      theme.bar.transparent = transparent;
      theme.bar.location = position;
      theme.bar.dropdownGap = "4.5em";
      theme.bar.menus.shadow =
        if transparent
        then "0 0 0 0"
        else "0px 0px 3px 1px #16161e";
      theme.bar.buttons.style = "default";
      theme.bar.buttons.monochrome = true;
      theme.bar.menus.monochrome = true;
      theme.bar.menus.card_radius = toString rounding + "px";
      theme.bar.menus.border.size = toString border-size + "px";
      theme.bar.menus.border.radius = toString rounding + "px";
      theme.bar.menus.menu.media.card.tint = 90;

      bar.launcher.icon = "";
      bar.workspaces.show_numbered = false;
      bar.workspaces.workspaces = 5;
      bar.workspaces.numbered_active_indicator = "color";
      bar.workspaces.monitorSpecific = false;
      bar.workspaces.applicationIconEmptyWorkspace = "";
      bar.workspaces.showApplicationIcons = true;
      bar.workspaces.showWsIcons = true;

      bar.windowtitle.label = true;
      bar.volume.label = false;
      bar.network.truncation_size = 12;
      bar.bluetooth.label = false;
      bar.clock.format = "%a %b %d  %I:%M %p";
      bar.notifications.show_total = true;
      bar.media.show_active_only = true;

      bar.customModules.updates.pollingInterval = 1440000;
      bar.customModules.cava.showIcon = false;
      bar.customModules.cava.stereo = true;
      bar.customModules.cava.showActiveOnly = true;

      notifications.position = "top right";
      notifications.showActionsOnHover = true;
      theme.notification.opacity = notificationOpacity;
      theme.notification.enableShadow = true;
      theme.notification.border_radius = toString rounding + "px";

      theme.osd.enable = true;
      theme.osd.orientation = "vertical";
      theme.osd.location = "left";
      theme.osd.radius = toString rounding + "px";
      theme.osd.margins = "0px 0px 0px 10px";
      theme.osd.muted_zero = true;

      menus.clock.weather.location = location;
      menus.clock.weather.unit = "metric";
      menus.dashboard.powermenu.confirmation = false;
      menus.dashboard.powermenu.avatar.image = "~/.face.icon";

      menus.dashboard.shortcuts.left.shortcut1.icon = "";
      menus.dashboard.shortcuts.left.shortcut1.command = "zen";
      menus.dashboard.shortcuts.left.shortcut1.tooltip = "Zen";
      menus.dashboard.shortcuts.left.shortcut2.icon = "󰅶";
      menus.dashboard.shortcuts.left.shortcut2.command = "caffeine";
      menus.dashboard.shortcuts.left.shortcut2.tooltip = "Caffeine";
      menus.dashboard.shortcuts.left.shortcut3.icon = "󰖔";
      menus.dashboard.shortcuts.left.shortcut3.command = "night-shift";
      menus.dashboard.shortcuts.left.shortcut3.tooltip = "Night-shift";
      menus.dashboard.shortcuts.left.shortcut4.icon = "";
      menus.dashboard.shortcuts.left.shortcut4.command = "menu";
      menus.dashboard.shortcuts.left.shortcut4.tooltip = "Search Apps";

      menus.dashboard.shortcuts.right.shortcut1.icon = "";
      menus.dashboard.shortcuts.right.shortcut1.command = "hyprpicker -a";
      menus.dashboard.shortcuts.right.shortcut1.tooltip = "Color Picker";
      menus.dashboard.shortcuts.right.shortcut3.icon = "󰄀";
      menus.dashboard.shortcuts.right.shortcut3.command = "screenshot region swappy";
      menus.dashboard.shortcuts.right.shortcut3.tooltip = "Screenshot";

      menus.power.lowBatteryNotification = true;

      wallpaper.enable = false;

      theme.bar.buttons.workspaces.hover = accent-alt;
      theme.bar.buttons.workspaces.active = accent;
      theme.bar.buttons.workspaces.available = accent-alt;
      theme.bar.buttons.workspaces.occupied = accent-alt;

      theme.bar.menus.background = background;
      theme.bar.menus.cards = background-alt;
      theme.bar.menus.label = foreground;
      theme.bar.menus.text = foreground;
      theme.bar.menus.border.color = accent;
      theme.bar.menus.popover.text = foreground;
      theme.bar.menus.popover.background = background-alt;
      theme.bar.menus.listitems.active = accent;
      theme.bar.menus.icons.active = accent;
      theme.bar.menus.switch.enabled = accent;
      theme.bar.menus.check_radio_button.active = accent;
      theme.bar.menus.buttons.default = accent;
      theme.bar.menus.buttons.active = accent;
      theme.bar.menus.iconbuttons.active = accent;
      theme.bar.menus.progressbar.foreground = accent;
      theme.bar.menus.slider.primary = accent;
      theme.bar.menus.tooltip.background = background-alt;
      theme.bar.menus.tooltip.text = foreground;
      theme.bar.menus.dropdownmenu.background = background-alt;
      theme.bar.menus.dropdownmenu.text = foreground;

      theme.bar.background =
        background
        + (
          if transparentButtons && transparent
          then "00"
          else ""
        );
      theme.bar.buttons.text =
        if transparent && transparentButtons
        then foregroundOnWallpaper
        else foreground;
      theme.bar.buttons.background =
        (
          if transparent
          then background
          else background-alt
        )
        + (
          if transparentButtons
          then "00"
          else ""
        );
      theme.bar.buttons.icon = accent;

      theme.bar.buttons.notifications.background = background-alt;
      theme.bar.buttons.hover = background;
      theme.bar.buttons.notifications.hover = background;
      theme.bar.buttons.notifications.total = accent;
      theme.bar.buttons.notifications.icon = accent;

      theme.osd.bar_color = accent;
      theme.osd.bar_overflow_color = accent-alt;
      theme.osd.icon = background;
      theme.osd.icon_container = accent;
      theme.osd.label = accent;
      theme.osd.bar_container = background-alt;

      theme.bar.menus.menu.media.background.color = background-alt;
      theme.bar.menus.menu.media.card.color = background-alt;

      theme.notification.background = background-alt;
      theme.notification.actions.background = accent;
      theme.notification.actions.text = foreground;
      theme.notification.label = accent;
      theme.notification.border = background-alt;
      theme.notification.text = foreground;
      theme.notification.labelicon = accent;
      theme.notification.close_button.background = background-alt;
      theme.notification.close_button.label = "#f38ba8";
    };
  };
}
