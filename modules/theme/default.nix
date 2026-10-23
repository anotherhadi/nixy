# Global theme, shared by every host
{lib, ...}: {
  options.theme = lib.mkOption {
    type = lib.types.attrs;
    readOnly = true;
    description = "Global theme";
    default = let
      colors = import ./_palette-catppuccin.nix;
      hexToRgb = hex: map (i: lib.fromHexString (builtins.substring i 2 hex)) [0 2 4];
    in {
      inherit colors;
      withHashtag = lib.mapAttrs (_: c: "#${c}") colors;
      rgb = lib.mapAttrs (_: hexToRgb) colors; # base00 = [r g b]
      polarity = "dark";

      # base24 slots in ANSI order (0-15), for terminal palettes
      ansi = [
        "base00" # black
        "base08" # red
        "base0B" # green
        "base0A" # yellow
        "base0D" # blue
        "base0E" # magenta
        "base0C" # cyan
        "base05" # white
        "base03" # bright black
        "base12" # bright red
        "base14" # bright green
        "base13" # bright yellow
        "base16" # bright blue
        "base17" # bright magenta
        "base15" # bright cyan
        "base07" # bright white
      ];

      fonts = {
        monospace = "Maple Mono NF";
        sansSerif = "Rubik";
        serif = "Rubik";
        emoji = "Noto Color Emoji";
        sizes = {
          applications = 13;
          popups = 13;
          terminal = 13;
        };
      };

      cursor = {
        name = "BreezeX-RosePine-Linux";
        size = 20;
      };

      icons = "Papirus-Dark";

      wallpaper = {
        url = "https://files.orangc.net/media/walls-catppuccin-mocha/degirled.png";
        sha256 = "sha256-Olmvjt/3ItdXP3b0VtEoLp7SXvPwMEnhKE7tP+rJ/9o=";
      };

      # Desktop look
      bar-height = 32;
      gaps-in = 8;
      gaps-out = 8;
      border-size = 4;
    };
  };
}
