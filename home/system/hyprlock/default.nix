{
  config,
  lib,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors;
  font = config.stylix.fonts.monospace.name;

  fontSize = 16;
  em = fontSize * 4.0 / 3.0;
  charW = em * 0.6;
  lineH = em * 1.32;

  round = x: builtins.floor (x + 0.5);
  px = x: toString (round x);

  paint = color: t: ''<span foreground="#${color}">${t}</span>'';
  fromFile = name: text: ''cmd[update:0] cat ${pkgs.writeText name text}'';

  inner = 42;
  width = inner + 2;
  valueCol = 13;

  spaces = n: lib.concatStrings (lib.genList (_: " ") n);

  border = paint c.base0D;
  hbar = lib.concatStrings (lib.genList (_: "─") inner);

  row = content: border "│" + content + border "│";

  blank = row (spaces inner);

  entry = name: value: let
    prompt = "  ${name}:";
    gap = spaces (valueCol - builtins.stringLength prompt);
    tail = spaces (inner - valueCol - builtins.stringLength value);
  in
    row (border prompt + gap + paint c.base05 value + tail);

  lines = [
    (border "┌${hbar}┐")
    blank
    (entry "Session" "Hyprland")
    (entry "Username" config.home.username)
    (entry "Password" "")
    blank
    (border "└${hbar}┘")
  ];

  rowY = i: -((i + 0.5) - (builtins.length lines) / 2.0) * lineH;
  colX = i: (i - width / 2.0) * charW;

  frameHalfH = (builtins.length lines) * lineH / 2.0;
  outsideY = frameHalfH + 1.5 * lineH;

  inputH = fontSize / 0.8;
  inputW = 27 * charW;
  dotPad = (inputH - lineH) / 2.0;
  inputX = colX (valueCol + 1) - dotPad;
  passwordRow = 4;
  hidden = "<span> </span>";
in {
  stylix.targets.hyprlock.enable = false;

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 2;
      };

      background = [
        {
          monitor = "";
          color = "rgba(${c.base00}FF)";
        }
      ];

      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] date +"%H:%M   %A %d %B"'';
          color = "rgb(${c.base05})";
          font_size = fontSize;
          font_family = font;
          position = "0, -64";
          halign = "center";
          valign = "top";
        }
        {
          monitor = "";
          text = "Welcome";
          color = "rgb(${c.base05})";
          font_size = fontSize;
          font_family = font;
          position = "0, ${px outsideY}";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = fromFile "hyprlock-frame" (lib.concatStringsSep "\n" lines);
          color = "rgb(${c.base05})";
          font_size = fontSize;
          font_family = font;
          text_align = "left";
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "<span> </span>$FAIL<span> </span>";
          color = "rgb(${c.base08})";
          font_size = fontSize;
          font_family = font;
          position = "0, ${px (-outsideY)}";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text =
            fromFile "hyprlock-hints"
            "${paint c.base0D "Enter"} ${paint c.base04 "unlock"}    ${paint c.base0D "Esc"} ${paint c.base04 "clear"}";
          color = "rgb(${c.base04})";
          font_size = fontSize;
          font_family = font;
          position = "0, 40";
          halign = "center";
          valign = "bottom";
        }
      ];

      "input-field" = [
        {
          monitor = "";
          size = "${px inputW}, ${px inputH}";
          position = "${px (inputX + inputW / 2.0)}, ${px (rowY passwordRow)}";
          halign = "center";
          valign = "center";

          outline_thickness = 0;
          outer_color = "rgba(00000000)";
          inner_color = "rgba(00000000)";
          rounding = 0;
          fade_on_empty = false;

          font_family = font;
          font_color = "rgb(${c.base05})";

          dots_text_format = "*";
          dots_size = 0.8;
          dots_spacing = 0.0;
          dots_center = false;

          swap_font_color = true;
          placeholder_text = hidden;
          fail_text = hidden;
          check_color = "rgb(${c.base0C})";
          fail_color = "rgb(${c.base08})";
          capslock_color = "rgb(${c.base0A})";
        }
      ];
    };
  };
}
