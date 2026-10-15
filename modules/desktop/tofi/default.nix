# Tofi: app launcher (top bar) and dmenu-style pickers
{config, ...}: let
  inherit (config) theme;
  c = theme.colors;
  barHeight = theme.bar-height;
  rounding =
    if theme.rounding > barHeight / 2
    then barHeight / 2
    else theme.rounding;
in {
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      lib,
      pkgs,
      ...
    }: {
      packages = [pkgs.tofi];

      xdg.config.files."tofi/config".text = lib.generators.toKeyValue {} {
        anchor = "top";
        height = barHeight;
        margin-top = theme.gaps-out;
        margin-left = 350;
        margin-right = 350;

        horizontal = true;
        num-results = 8;
        result-spacing = 20;
        padding-top = 2;
        padding-bottom = 2;
        padding-left = 14;
        padding-right = 14;

        font = theme.fonts.serif;
        font-size = theme.fonts.sizes.popups;

        text-color = "#${c.base05}";
        prompt-color = "#${c.base0D}ff";
        selection-color = "#${c.base0D}ff";
        placeholder-color = "#${c.base03}FF";
        background-color = "#${c.base00}FF";
        input-background = "#${c.base00}FF";
        prompt-background = "#${c.base00}FF";
        selection-background = "#${c.base00}FF";
        default-result-background = "#${c.base00}FF";
        border-color = "#${c.base05}";
        outline-color = "#${c.base04}FF";

        outline-width = 0;
        border-width = 0;
        corner-radius = rounding;

        prompt-text = "  ";
        placeholder-text = "Search...";

        drun-launch = true;
      };
    })
  ];
}
