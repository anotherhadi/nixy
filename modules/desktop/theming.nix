# GTK theme (adw-gtk3 recolored with the palette), icons, cursor and fonts
# for GTK apps; Qt apps follow GTK (QT_QPA_PLATFORMTHEME=gtk3 in Hyprland)
{config, ...}: let
  inherit (config) theme;
  c = theme.withHashtag;
  inherit (theme) cursor;
  font = "${theme.fonts.sansSerif} ${toString theme.fonts.sizes.applications}";

  gtkSettings = {
    gtk-theme-name = "adw-gtk3";
    gtk-icon-theme-name = theme.icons;
    gtk-cursor-theme-name = cursor.name;
    gtk-cursor-theme-size = cursor.size;
    gtk-font-name = font;
  };

  # libadwaita named colors (same template as stylix's gtk target)
  gtkCss = let
    rgba = base: alpha: let
      rgb = map (x: toString (x / 256.0)) theme.rgb.${base};
    in "rgba(${builtins.concatStringsSep ", " rgb}, ${alpha})";
    shade = "rgba(0, 0, 0, 0.07)";
    ramp = name: base:
      builtins.concatStringsSep "\n" (map (i: "@define-color ${name}_${toString i} ${c.${base}};") [1 2 3 4 5]);
  in ''
    @define-color accent_color ${c.base0D};
    @define-color accent_bg_color ${c.base0D};
    @define-color accent_fg_color ${c.base00};
    @define-color destructive_color ${c.base08};
    @define-color destructive_bg_color ${c.base08};
    @define-color destructive_fg_color ${c.base00};
    @define-color success_color ${c.base0B};
    @define-color success_bg_color ${c.base0B};
    @define-color success_fg_color ${c.base00};
    @define-color warning_color ${c.base0E};
    @define-color warning_bg_color ${c.base0E};
    @define-color warning_fg_color ${c.base00};
    @define-color error_color ${c.base08};
    @define-color error_bg_color ${c.base08};
    @define-color error_fg_color ${c.base00};
    @define-color window_bg_color ${c.base00};
    @define-color window_fg_color ${c.base05};
    @define-color view_bg_color ${c.base00};
    @define-color view_fg_color ${c.base05};
    @define-color headerbar_bg_color ${c.base01};
    @define-color headerbar_fg_color ${c.base05};
    @define-color headerbar_border_color ${rgba "base01" "0.7"};
    @define-color headerbar_backdrop_color @window_bg_color;
    @define-color headerbar_shade_color ${shade};
    @define-color headerbar_darker_shade_color ${shade};
    @define-color sidebar_bg_color ${c.base01};
    @define-color sidebar_fg_color ${c.base05};
    @define-color sidebar_backdrop_color @window_bg_color;
    @define-color sidebar_shade_color ${shade};
    @define-color secondary_sidebar_bg_color @sidebar_bg_color;
    @define-color secondary_sidebar_fg_color @sidebar_fg_color;
    @define-color secondary_sidebar_backdrop_color @sidebar_backdrop_color;
    @define-color secondary_sidebar_shade_color @sidebar_shade_color;
    @define-color card_bg_color ${c.base01};
    @define-color card_fg_color ${c.base05};
    @define-color card_shade_color ${shade};
    @define-color dialog_bg_color ${c.base01};
    @define-color dialog_fg_color ${c.base05};
    @define-color popover_bg_color ${c.base01};
    @define-color popover_fg_color ${c.base05};
    @define-color popover_shade_color ${shade};
    @define-color shade_color ${shade};
    @define-color scrollbar_outline_color ${c.base02};
    ${ramp "blue" "base0D"}
    ${ramp "green" "base0B"}
    ${ramp "yellow" "base0A"}
    ${ramp "orange" "base09"}
    ${ramp "red" "base08"}
    ${ramp "purple" "base0E"}
    ${ramp "brown" "base0F"}
    ${ramp "light" "base05"}
    ${ramp "dark" "base05"}
  '';
in {
  flake.modules.nixos.desktop = {lib, ...}: {
    # GSettings read by GTK4/libadwaita apps and portals
    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/desktop/interface" = {
          color-scheme = "prefer-${theme.polarity}";
          gtk-theme = "adw-gtk3";
          icon-theme = theme.icons;
          cursor-theme = cursor.name;
          cursor-size = lib.gvariant.mkInt32 cursor.size;
          font-name = font;
          document-font-name = "${theme.fonts.sansSerif} ${toString (theme.fonts.sizes.applications - 1)}";
          monospace-font-name = "${theme.fonts.monospace} ${toString theme.fonts.sizes.applications}";
        };
      }
    ];

    hjem.extraModules = [
      ({
        config,
        pkgs,
        ...
      }: let
        ini = lib.generators.toINI {} {Settings = gtkSettings;};
      in {
        packages = with pkgs; [
          adw-gtk3
          papirus-icon-theme
          rose-pine-cursor
        ];

        xdg.config.files = {
          "gtk-3.0/settings.ini".text = ini;
          "gtk-4.0/settings.ini".text = ini;
          "gtk-3.0/gtk.css".text = gtkCss;
          "gtk-4.0/gtk.css".text = gtkCss;
        };

        files.".gtkrc-2.0".text = lib.concatLines (lib.mapAttrsToList (k: v: "${k} = ${
            if builtins.isString v
            then ''"${v}"''
            else toString v
          }")
          gtkSettings);

        # Default cursor for X11 apps (Xwayland)
        files.".icons/default/index.theme".text = ''
          [Icon Theme]
          Name=Default
          Comment=Default Cursor Theme
          Inherits=${cursor.name}
        '';

        environment.sessionVariables = {
          GTK2_RC_FILES = "${config.directory}/.gtkrc-2.0";
          XCURSOR_THEME = cursor.name;
          XCURSOR_SIZE = cursor.size;
        };
      })
    ];
  };
}
