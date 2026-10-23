# Tofi: app launcher and dmenu-style pickers
{config, ...}: let
  inherit (config) theme;
  c = theme.colors;
  barHeight = theme.bar-height;
  lineHeight = 22;
  padY = (barHeight - lineHeight) / 2;

  menuResults = 10;
  menuSpacing = 6;
  menuHeight = barHeight + menuResults * (menuSpacing + lineHeight);
in {
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      lib,
      pkgs,
      ...
    }: let
      output = ''$(${pkgs.sway}/bin/swaymsg -rt get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | "--output \(.name)"')'';
    in {
      scripts.tofi-drun-toggle = pkgs.writeShellScriptBin "tofi-drun-toggle" ''
        if ${pkgs.procps}/bin/pkill -x tofi-drun; then
          exit 0
        fi
        exec ${pkgs.tofi}/bin/tofi-drun ${output}
      '';

      scripts.tofi-menu = pkgs.writeShellScriptBin "tofi-menu" ''
        exec ${pkgs.tofi}/bin/tofi ${output} --horizontal false --height ${toString menuHeight} \
          --num-results ${toString menuResults} --result-spacing ${toString menuSpacing} \
          --padding-bottom ${toString padY} "$@"
      '';

      packages = [pkgs.tofi];

      xdg.config.files."tofi/config".text = lib.generators.toKeyValue {} {
        # Covers the bar exactly: full width, flush with the top
        anchor = "top";
        width = "100%";
        height = barHeight;

        horizontal = true;
        num-results = 16;
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

        outline-width = 0;
        border-width = 0;

        prompt-text = "  ";
        placeholder-text = "Search...";

        drun-launch = true;
      };
    })
  ];
}
