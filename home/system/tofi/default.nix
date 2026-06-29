{
  config,
  lib,
  ...
}: let
  c = config.lib.stylix.colors;
  font = config.stylix.fonts.serif.name;
  gaps = config.theme.gaps-out;
  barHeight = config.theme.bar-height;
  rounding =
    if config.theme.rounding > barHeight / 2
    then barHeight / 2
    else config.theme.rounding;
in {
  programs.tofi = {
    enable = true;
    settings = {
      anchor = "top";
      height = barHeight;
      margin-top = gaps;
      margin-left = 350;
      margin-right = 350;

      horizontal = true;
      num-results = 8;
      result-spacing = 20;
      padding-top = 2;
      padding-bottom = 2;
      padding-left = 14;
      padding-right = 14;

      font = lib.mkForce font;
      prompt-color = lib.mkForce "#${c.base0D}ff";

      outline-width = 0;
      border-width = 0;
      corner-radius = rounding;

      prompt-text = "  ";
      placeholder-text = "Search...";

      drun-launch = true;
    };
  };
}
