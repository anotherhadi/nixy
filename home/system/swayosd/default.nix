{
  config,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors;
  rounding = config.theme.rounding;
  border-size = config.theme.border-size;
  gaps-in = config.theme.gaps-in;
  opacityToHex = opacity: let
    val = builtins.floor (opacity * 255);
    high = val / 16;
    low = val - high * 16;
    digits = "0123456789abcdef";
  in "${builtins.substring high 1 digits}${builtins.substring low 1 digits}";
  alphaHex = opacityToHex config.theme.inactive-opacity;

  style = pkgs.writeText "swayosd-style.css" ''
    window#osd {
      background: #${c.base00}${alphaHex};
      border-radius: ${toString rounding}px;
      border: ${toString border-size}px solid #${c.base03}66;
    }

    window#osd #container {
      margin: ${toString gaps-in}px;
      padding: 4px;
    }

    window#osd image,
    window#osd label {
      color: #${c.base05};
    }

    window#osd progressbar,
    window#osd segmentedprogress {
      min-height: 6px;
      border-radius: 999px;
      background: transparent;
      border: none;
    }

    window#osd trough,
    window#osd segment {
      min-height: inherit;
      border-radius: inherit;
      border: none;
      background: #${c.base03}66;
    }

    window#osd progress,
    window#osd segment.active {
      min-height: inherit;
      border-radius: inherit;
      border: none;
      background: #${c.base0D};
    }

    window#osd segment { margin-left: 4px; }
    window#osd segment:first-child { margin-left: 0; }
  '';
in {
  services.swayosd = {
    enable = false;
    stylePath = style;
    topMargin = 0.06;
  };
}
