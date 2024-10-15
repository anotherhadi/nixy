# Tofi is a dmeny-like application launcher
{ config, lib, ... }:
let
  background = "#${config.lib.stylix.colors.base00}70";
  accent = "#${config.lib.stylix.colors.base0D}";
in {
  programs.tofi = lib.mkForce {
    enable = true;
    settings = {
      border-width = 0;
      background-color = background;
      prompt-color = accent;
      selection-color = accent;
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
