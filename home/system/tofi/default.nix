{ config, ... }:
let
  background = "#${config.lib.stylix.colors.base00}";
  font = "${config.stylix.fonts.serif.name}";
in {
  programs.tofi = {
    enable = true;
    settings = {
      background-color = background;
      border-width = 0;
      font = font;
      height = "100%";
      num-results = 5;
      outline-width = 0;
      padding-left = "35%";
      padding-top = "35%";
      result-spacing = 25;
      width = "100%";
    };
  };
}
