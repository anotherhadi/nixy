{ config, pkgs, ... }: {

  home.packages = with pkgs; [ libnotify ];

  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Moka";
      package = pkgs.moka-icon-theme;
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
        corner_radius = config.var.theme.rounding;
        follow = "mouse";
        font = config.var.theme.font;
        format = "<b>%s</b>\\n%b";
        progress_bar_corner_radius = config.var.theme.rounding - 10;
        #format = ''
        #  <span foreground='#${config.var.theme.colors.accent}'><b>%s %p</b></span>
        #  %b'';
        frame_color = "#" + config.var.theme.colors.bg;
        highlight = "#" + config.var.theme.colors.accent;
        foreground = "#" + config.var.theme.colors.fg;
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
        background = "#" + config.var.theme.colors.c1;
        foreground = "#" + config.var.theme.colors.c0;
      };
      urgency_low = {
        background = "#" + config.var.theme.colors.bgalt;
        foreground = "#" + config.var.theme.colors.fgalt;
      };
      urgency_normal = {
        background = "#" + config.var.theme.colors.bgalt;
        foreground = "#" + config.var.theme.colors.fgalt;
      };
    };
  };
}
