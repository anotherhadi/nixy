{ config, lib, pkgs, ... }: {

  home.packages = with pkgs; [ libnotify ];

  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Adwaita-Dark";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    settings = {
      global = {
        rounded = "yes";
        origin = "top-center";
        monitor = "0";
        alignment = "center";
        vertical_alignment = "center";
        width = "400";
        height = "400";
        scale = 0;
        gap_size = 0;
        progress_bar = true;
        transparency = 0;
        text_icon_padding = 0;
        separator_color = "frame";
        sort = "yes";
        idle_threshold = 120;
        line_height = 0;
        markup = "full";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        sticky_history = "yes";
        history_length = 20;
        always_run_script = true;
        corner_radius = config.theme.rounding;
        follow = "mouse";
        font = config.theme.font;
        format = "<b>%s</b>\\n%b";
        progress_bar_corner_radius = config.theme.rounding - 10;
        #format = ''
        #  <span foreground='#${config.theme.colors.primary-bg}'><b>%s %p</b></span>
        #  %b'';
        frame_color = "#" + config.theme.colors.bg;
        highlight = "#" + config.theme.colors.primary-bg;
        foreground = "#" + config.theme.colors.fg;
        frame_width = 1;
        offset = "0x10";
        horizontal_padding = 10;
        icon_position = "left";
        indicate_hidden = "yes";
        min_icon_size = 0;
        max_icon_size = 64;
        mouse_left_click = "do_action, close_current";
        mouse_middle_click = "close_current";
        mouse_right_click = "close_all";
        padding = 10;
        plain_text = "no";
        separator_height = 2;
        show_indicators = "yes";
        shrink = "no";
        word_wrap = "yes";
        browser = "${pkgs.qutebrowser}/bin/qutebrowser";
      };

      fullscreen_delay_everything = { fullscreen = "delay"; };

      urgency_critical = {
        background = "#" + config.theme.colors.color1;
        foreground = "#" + config.theme.colors.color0;
      };
      urgency_low = {
        background = "#" + config.theme.colors.alt-bg;
        foreground = "#" + config.theme.colors.alt-fg;
      };
      urgency_normal = {
        background = "#" + config.theme.colors.alt-bg;
        foreground = "#" + config.theme.colors.alt-fg;
      };
    };
  };
}
