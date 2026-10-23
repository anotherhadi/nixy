# System side of the theme
{config, ...}: let
  inherit (config) theme;
  c = theme.colors;
in {
  flake.modules.nixos.theme = {pkgs, ...}: {
    fonts = {
      packages = with pkgs; [
        maple-mono.NF # monospace
        rubik # sansSerif / serif
        noto-fonts-color-emoji # emoji
      ];

      fontconfig.defaultFonts = {
        monospace = [theme.fonts.monospace];
        sansSerif = [theme.fonts.sansSerif];
        serif = [theme.fonts.serif];
        emoji = [theme.fonts.emoji];
      };
    };

    # Linux console (TTY), ANSI order
    console.colors = map (base: c.${base}) theme.ansi;
  };
}
