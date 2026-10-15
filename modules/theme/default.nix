# Global theme, shared by every host
# Read it from any flake-parts module as config.theme (capture it in the outer let,
# inside flake.modules.<class>.<name> `config` is the NixOS/hjem one)
{lib, ...}: {
  options.theme = lib.mkOption {
    type = lib.types.attrs;
    readOnly = true;
    description = "Global theme: base16 palette (hex without #), fonts, cursor, wallpaper and UI sizes";
    default = let
      colors = import ./_palette.nix;
      hexToRgb = hex: map (i: lib.fromHexString (builtins.substring i 2 hex)) [0 2 4];
    in {
      inherit colors;
      withHashtag = lib.mapAttrs (_: c: "#${c}") colors;
      rgb = lib.mapAttrs (_: hexToRgb) colors; # base00 = [r g b]
      polarity = "dark";

      # Names only, packages are installed in theme/nixos.nix
      fonts = {
        monospace = "Maple Mono NF";
        sansSerif = "Rubik";
        serif = "Rubik";
        emoji = "Noto Color Emoji";
        sizes = {
          applications = 13;
          desktop = 13;
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
        url = "https://raw.githubusercontent.com/anotherhadi/awesome-wallpapers/main/wallpapers/another-one.png";
        sha256 = "sha256-bKke8RNz6qNxHSfLbU5xVVkG3tbFZW1sFjLB1hltcoI=";
      };

      # Desktop look
      rounding = 20;
      bar-height = 36;
      gaps-in = 8;
      gaps-out = 8 * 2;
      active-opacity = 0.96;
      inactive-opacity = 0.92;
      blur = false;
      border-size = 2;
      animation-speed = "very-fast"; # "very-fast" | "fast" | "medium" | "slow"
    };
  };
}
