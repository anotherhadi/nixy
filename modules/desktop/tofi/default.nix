# Tofi: app launcher (top bar) and dmenu-style pickers
{config, ...}: let
  inherit (config) theme;
  c = theme.colors;
  barHeight = theme.bar-height;
  # Height of a text line in Pango (Rubik at the popups size): tofi draws text
  # from the top padding without centering it, so the padding does the centering
  lineHeight = 22;
  padY = (barHeight - lineHeight) / 2;

  # Vertical menus: the prompt sits on the bar, the results below
  menuResults = 10;
  menuSpacing = 6;
  menuHeight = barHeight + menuResults * (menuSpacing + lineHeight);
in {
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      lib,
      pkgs,
      scripts,
      ...
    }: {
      # dmenu-style menu reading choices from stdin, for the pickers
      scripts.tofi-menu = pkgs.writeShellScriptBin "tofi-menu" ''
        exec ${pkgs.tofi}/bin/tofi --horizontal false --height ${toString menuHeight} \
          --num-results ${toString menuResults} --result-spacing ${toString menuSpacing} \
          --padding-bottom ${toString padY} "$@"
      '';

      packages = [pkgs.tofi];

      xdg.config.files."tofi/config".text = lib.generators.toKeyValue {} {
        # Covers the bar exactly: full width, flush with the top
        anchor = "top";
        width = "100%";
        height = barHeight;
        margin-top = 0;
        margin-left = 0;
        margin-right = 0;

        horizontal = true;
        num-results = 8;
        result-spacing = 20;
        padding-top = padY;
        padding-bottom = 0;
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
        corner-radius = 0;

        prompt-text = "  ";
        placeholder-text = "Search...";

        drun-launch = true;
      };
    })
  ];
}
