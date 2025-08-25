# Wofi is a launcher for Wayland, inspired by rofi.
{
  config,
  pkgs,
  lib,
  ...
}: let
  accent = "#${config.lib.stylix.colors.base0D}";
  background = "#${config.lib.stylix.colors.base00}";
  background-alt = "#${config.lib.stylix.colors.base01}";
  foreground = "#${config.lib.stylix.colors.base05}";
  font = config.stylix.fonts.serif.name;
  rounding = config.theme.rounding;
  font-size = config.stylix.fonts.sizes.popups;
in {
  home.packages = with pkgs; [wofi-emoji];

  programs.wofi = {
    enable = true;

    settings = {
      allow_markup = true;
      width = 650;
      show = "drun";
      prompt = "Apps";
      normal_window = true;
      height = 325;
      allow_images = true;
      image_size = 24;
      insensitive = true;
      hide_scroll = true;
      no_actions = true;
      gtk_dark = true;
    };

    style =
      lib.mkForce
      # css
      ''
        * {
          font-family: "${font}";
          font-weight: 600;
          font-size: ${toString font-size}px;
        }

        #window {
          background-color: ${background};
          color: ${foreground};
          border-radius: ${toString rounding}px;
        }

        #outer-box {
          padding: 20px;
        }

        #input {
          background-color: ${background-alt};
          border: 0px solid ${accent};
          color: ${foreground};
          padding: 8px 12px;
        }

        #scroll {
          margin-top: 20px;
        }

        #inner-box {}

        #img {
          padding-right: 8px;
        }

        #text {
          color: ${foreground};
        }

        #text:selected {
          color: ${foreground};
        }

        #entry {
          padding: 6px;
        }

        #entry:selected {
          background-color: ${accent};
          color: ${foreground};
        }

        #unselected {}

        #selected {}

        #input,
        #entry:selected {
          border-radius: ${toString rounding}px;
        }
      '';
  };
}
