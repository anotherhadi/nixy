{
  imports = [ ./config/template.nix ];

  theme = {
    wallpaper = "house_cloud.png";

    font-mono = "FiraCode Nerd Font Mono";
    font = "SFProDisplay Nerd Font";

    rounding = 8;
    gaps-in = 6;
    gaps-out = 12;
    border-size = 2;

    neofetch = "nerdfetch";

    waybar = {
      transparent = false;
      float = false;
    };

    colors = {
      bg = "040409";
      fg = "FCFCFC";
      alt-bg = "101012";
      alt-fg = "ECECEC";

      primary-ansi-16 = "cyan";
      primary-bg = "bbcde5";
      primary-fg = "000000";

      secondary-bg = "4928B8";
      secondary-fg = "000000";

      # Black
      color0 = "000000";
      # Red
      color1 = "f7768e";
      # Green
      color2 = "73daca";
      # Yellow
      color3 = "e0af68";
      # Blue
      color4 = "7aa2f7";
      # Magenta
      color5 = "9978F8";
      # Cyan
      color6 = "bbcde5";
      # White
      color7 = "E4E5E7";

      # Bright
      color8 = "515878";
      color9 = "f7869e";
      color10 = "83eada";
      color11 = "f0bf78";
      color12 = "8ab2f7";
      color13 = "A988F8";
      color14 = "ccdef6";
      color15 = "f4f5f7";
    };
  };

}
