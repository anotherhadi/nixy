{ config, pkgs, lib, ... }: {

  home.packages = with pkgs; [ wofi-emoji ];

  programs.wofi = {
    enable = true;

    settings = {
      allow_markup = true;
      width = 450;
      show = "drun";
      prompt = "Apps";
      normal_window = true;
      layer = "top";
      term = "foot";
      height = "305px";
      orientation = "vertical";
      halign = "fill";
      line_wrap = "off";
      dynamic_lines = false;
      allow_images = true;
      image_size = 24;
      exec_search = false;
      hide_search = false;
      parse_search = false;
      insensitive = true;
      hide_scroll = true;
      no_actions = true;
      sort_order = "default";
      gtk_dark = true;
      filter_rate = 100;
      key_expand = "Tab";
      key_exit = "Escape";
    };

    style = lib.mkForce
      # css
      ''
        * {
          font-family: "${config.stylix.fonts.serif.name}";
          font-weight: 500;
          font-size: 13px;
        }

        #window {
          background-color: #${config.lib.stylix.colors.base01};
          color: #${config.lib.stylix.colors.base06};
          border-radius: ${toString config.var.theme.rounding}px;
        }

        #outer-box {
          padding: 20px;
        }

        #input {
          background-color: #${config.lib.stylix.colors.base00};
          border: 0px solid #${config.lib.stylix.colors.base0D};
          color: #${config.lib.stylix.colors.base05};
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
          color: #${config.lib.stylix.colors.base05};
        }

        #text:selected {
          color: #${config.lib.stylix.colors.base05};
        }

        #entry {
          padding: 6px;
        }

        #entry:selected {
          background-color: #${config.lib.stylix.colors.base0D};
          color: #${config.lib.stylix.colors.base05};
        }

        #unselected {}

        #selected {}

        #input,
        #entry:selected {
          border-radius: ${toString config.var.theme.rounding}px;
        }
      '';
  };
}
