{ config, pkgs, ... }: {

  qt = {
    enable = true;
    platformTheme.name = "gtk2";
    style.name = "gtk2";
  };

  gtk = {
    enable = true;

    theme = { name = "FlatColor"; };

    iconTheme = {
      package = pkgs.moka-icon-theme;
      name = "Moka";
    };

    font = {
      name = config.var.theme.font;
      size = config.var.theme.font-size;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 14;
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
      bg_color:#${config.var.theme.colors.bg}
      color0:#${config.var.theme.colors.c0}
      color1:#${config.var.theme.colors.c1}
      color2:#${config.var.theme.colors.c2}
      color3:#${config.var.theme.colors.c3}
      color4:#${config.var.theme.colors.c4}
      color5:#${config.var.theme.colors.c5}
      color6:#${config.var.theme.colors.c6}
      color7:#${config.var.theme.colors.c7}
      color8:#${config.var.theme.colors.c8}
      color9:#${config.var.theme.colors.c9}
      color10:#${config.var.theme.colors.c10}
      color11:#${config.var.theme.colors.c11}
      color12:#${config.var.theme.colors.c12}
      color13:#${config.var.theme.colors.c13}
      color14:#${config.var.theme.colors.c14}
      color15:#${config.var.theme.colors.c15}
      text_color:#${config.var.theme.colors.fg}
      selected_bg_color:#${config.var.theme.colors.accent}
      selected_fg_color:#${config.var.theme.colors.accentFg}
      tooltip_bg_color:#${config.var.theme.colors.bgalt}
      tooltip_fg_color:#${config.var.theme.colors.fgalt}
      titlebar_bg_color:#${config.var.theme.colors.bgalt}
      titlebar_fg_color:#${config.var.theme.colors.fgalt}
      menu_bg_color:#${config.var.theme.colors.bgalt}
      menu_fg_color:#${config.var.theme.colors.fgalt}
      link_color:#${config.var.theme.colors.accent}
    '';

    ".local/share/themes/FlatColor/colors3".text = ''
      @define-color color0 #${config.var.theme.colors.c0};
      @define-color color1 #${config.var.theme.colors.c1};
      @define-color color2 #${config.var.theme.colors.c2};
      @define-color color3 #${config.var.theme.colors.c3};
      @define-color color4 #${config.var.theme.colors.c4};
      @define-color color5 #${config.var.theme.colors.c5};
      @define-color color6 #${config.var.theme.colors.c6};
      @define-color color7 #${config.var.theme.colors.c7};
      @define-color color8 #${config.var.theme.colors.c8};
      @define-color color9 #${config.var.theme.colors.c9};
      @define-color color10 #${config.var.theme.colors.c10};
      @define-color color11 #${config.var.theme.colors.c11};
      @define-color color12 #${config.var.theme.colors.c12};
      @define-color color13 #${config.var.theme.colors.c13};
      @define-color color14 #${config.var.theme.colors.c14};
      @define-color color15 #${config.var.theme.colors.c15};
      @define-color selected_bg_color #${config.var.theme.colors.accent};
      @define-color selected_fg_color #${config.var.theme.colors.accentFg};

      @define-color bg_color #${config.var.theme.colors.bg};
      @define-color fg_color #${config.var.theme.colors.fg};
      @define-color base_color @bg_color;
      @define-color text_color @fg_color;
      @define-color text_color_disabled mix(@text_color, @base_color, 0.4);
      @define-color tooltip_bg_color #${config.var.theme.colors.bgalt};
      @define-color tooltip_fg_color #${config.var.theme.colors.fgalt};
    '';
  };
}
