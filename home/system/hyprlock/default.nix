{config, ...}: let
  c = config.lib.stylix.colors;
in {
  stylix.targets.hyprlock.enable = false;

  programs.hyprlock = {
    enable = true;
    settings = {
      background = [
        {
          monitor = "";
          color = "rgba(${c.base00}FF)";
        }
      ];

      label = [
        {
          monitor = "";
          text = ''cmd[update:0] echo "[$USER@$(hostname) ~]"'';
          color = "rgb(${c.base0D})";
          font_size = 13;
          font_family = "Maple Mono NF";
          position = "48, -48";
          halign = "left";
          valign = "top";
        }
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +'%H:%M:%S')"'';
          color = "rgb(${c.base05})";
          font_size = 13;
          font_family = "Maple Mono NF";
          position = "48, -70";
          halign = "left";
          valign = "top";
        }
        {
          monitor = "";
          text = ''cmd[update:60000] echo "$(date +'%A %d %B %Y')"'';
          color = "rgb(${c.base04})";
          font_size = 13;
          font_family = "Maple Mono NF";
          position = "48, -92";
          halign = "left";
          valign = "top";
        }
        {
          monitor = "";
          text = "passwd:";
          color = "rgb(${c.base0D})";
          font_size = 13;
          font_family = "Maple Mono NF";
          position = "48, -141";
          halign = "left";
          valign = "top";
        }
      ];

      "input-field" = [
        {
          monitor = "";
          size = "200, 20";
          outline_thickness = 0;
          outer_color = "rgba(00000000)";
          inner_color = "rgba(00000000)";
          font_color = "rgb(${c.base05})";
          fade_on_empty = false;
          placeholder_text = "";
          hide_input = true;
          rounding = 0;
          check_color = "rgb(${c.base0B})";
          fail_color = "rgb(${c.base08})";
          fail_text = ''<span font_desc="Maple Mono NF 13">auth failed</span>'';
          capslock_color = "rgb(${c.base0A})";
          position = "116, -138";
          halign = "left";
          valign = "top";
        }
      ];
    };
  };
}
