# GTK & QT theme configuration
{ config, pkgs, lib, ... }:
let
  accent = "#${config.lib.stylix.colors.base0D}";
  foreground = "#${config.lib.stylix.colors.base05}";
  background = "#${config.lib.stylix.colors.base00}";
  background-alt = "#${config.lib.stylix.colors.base01}";

  c0 = "#${config.lib.stylix.colors.base00}";
  c1 = "#${config.lib.stylix.colors.base08}";
  c2 = "#${config.lib.stylix.colors.base0B}";
  c3 = "#${config.lib.stylix.colors.base0A}";
  c4 = "#${config.lib.stylix.colors.base0D}";
  c5 = "#${config.lib.stylix.colors.base0E}";
  c6 = "#${config.lib.stylix.colors.base0C}";
  c7 = "#${config.lib.stylix.colors.base05}";
  c8 = "#${config.lib.stylix.colors.base03}";
  c9 = "#${config.lib.stylix.colors.base08}";
  c10 = "#${config.lib.stylix.colors.base0B}";
  c11 = "#${config.lib.stylix.colors.base0A}";
  c12 = "#${config.lib.stylix.colors.base0D}";
  c13 = "#${config.lib.stylix.colors.base0E}";
  c14 = "#${config.lib.stylix.colors.base0C}";
  c15 = "#${config.lib.stylix.colors.base07}";

in {

  qt = {
    enable = true;
    platformTheme.name = "gtk2";
    style.name = "gtk2";
  };

  gtk = {
    enable = true;

    theme = lib.mkForce { name = "FlatColor"; };

    iconTheme = {
      package = pkgs.kora-icon-theme;
      name = "Kora";
    };

    font = { name = config.stylix.fonts.serif.name; };

    gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };

    gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
  };

  home.file = {
    ".local/share/themes/FlatColor" = {
      recursive = true;
      source = pkgs.stdenv.mkDerivation {
        name = "FlatColor";

        src = pkgs.fetchFromGitHub {
          owner = "jasperro";
          repo = "FlatColor";
          rev = "0a56c50e8c5e2ad35f6174c19a00e01b30874074";
          hash = "sha256-P8RnYTk9Z1rCBEEMLTVRrNr5tUM/Pc9dsdMtpHd1Y18=";
        };

        buildPhase = ''
          mkdir -p $out
          # delete the default gtk-color-scheme:
          file="./gtk-2.0/gtkrc"
          sed -i '3,29d' $file
          sed -i '3i include "../colors2"' $file

          file="./gtk-3.0/gtk.css"
          sed -i '2,10d' $file
          sed -i '2i @import url("../colors3");' $file

          file="./gtk-3.20/gtk.css"
          sed -i '2,26d' $file
          sed -i '2i @import url("../colors3");' $file

          cp -r . $out 
        '';
      };
    };

    ".local/share/themes/FlatColor/colors2".text = ''
      bg_color:${background}
      color0:${c0}
      color1:${c1}
      color2:${c2}
      color3:${c3}
      color4:${c4}
      color5:${c5}
      color6:${c6}
      color7:${c7}
      color8:${c8}
      color9:${c9}
      color10:${c10}
      color11:${c11}
      color12:${c12}
      color13:${c13}
      color14:${c14}
      color15:${c15}
      text_color:${foreground}
      selected_bg_color:${accent}
      selected_fg_color:${foreground}
      tooltip_bg_color:${background-alt}
      tooltip_fg_color:${foreground}
      titlebar_bg_color:${background}
      titlebar_fg_color:${foreground}
      menu_bg_color:${background-alt}
      menu_fg_color:${foreground}
      link_color:${accent}
    '';

    ".local/share/themes/FlatColor/colors3".text = ''
      @define-color color0 ${c0};
      @define-color color1 ${c1};
      @define-color color2 ${c2};
      @define-color color3 ${c3};
      @define-color color4 ${c4};
      @define-color color5 ${c5};
      @define-color color6 ${c6};
      @define-color color7 ${c7};
      @define-color color8 ${c8};
      @define-color color9 ${c9};
      @define-color color10 ${c10};
      @define-color color11 ${c11};
      @define-color color12 ${c12};
      @define-color color13 ${c13};
      @define-color color14 ${c14};
      @define-color color15 ${c15};
      @define-color selected_bg_color ${accent};
      @define-color selected_fg_color ${foreground};
      @define-color bg_color ${background};
      @define-color fg_color ${foreground};
      @define-color base_color @bg_color;
      @define-color text_color @fg_color;
      @define-color text_color_disabled mix(@text_color, @base_color, 0.4);
      @define-color tooltip_bg_color ${background-alt};
      @define-color tooltip_fg_color ${foreground};
    '';
  };
}
