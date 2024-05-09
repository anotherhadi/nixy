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
      primary-bg = "BBCDE5";
      primary-fg = "000000";
      secondary-bg = "4928B8";
      secondary-fg = "000000";
      color0 = "000000";
      color1 = "f7768e";
      color2 = "73daca";
      color3 = "e0af68";
      color4 = "7aa2f7";
      color5 = "9978F8";
      color6 = "7dcfff";
      color7 = "E4E5E7";
      color8 = "515878";
      color9 = "f7869e";
      color10 = "83eada";
      color11 = "f0bf78";
      color12 = "8ab2f7";
      color13 = "A988F8";
      color14 = "8ddfff";
      color15 = "f4f5f7";
    };
  };

}
