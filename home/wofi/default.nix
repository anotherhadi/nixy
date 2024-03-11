{
  programs.wofi = {
    enable = true;

    settings = {
      allow_markup = true;
      width = 250;
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

    style = ''
      /** ********** Fonts ********** **/

      * {
        font-family: "SFProDisplay Nerd Font Bold", archcraft, sans-serif;
        font-size: 12px;
      }

      #window {
        background-color: #0B0B13;
        color: #D9E0EE;
        border: 2px solid #1B1B23;
        border-radius: 0px;
      }

      #outer-box {
        padding: 20px;
      }

      #input {
        background-color: #1B1B23;
        border: 0px solid #B4BEFE;
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
        color: #D9E0EE;
      }

      #text:selected {
        color: #0B0B13;
      }

      #entry {
        padding: 6px;
      }

      #entry:selected {
        background-color: #B4BEFE;
        color: #0B0B13;
      }

      #unselected {}

      #selected {}

      #input,
      #entry:selected {
        border-radius: 4px;
      }
    '';
  };
}
