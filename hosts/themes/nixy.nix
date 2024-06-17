{
  wallpaper = "lofi-computer.png";

  font = "SFProDisplay Nerd Font";
  font-mono = "FiraCode Nerd Font Mono";
  font-size = 13;

  rounding = 15;
  gaps-in = 12;
  gaps-out = 12 * 2;
  border-size = 4;
  animation-speed = "slow"; # "fast" | "medium" | "slow"
  fetch = "nerdfetch"; # "nerdfetch" | "neofetch" | "none"

  waybar = {
    transparent = true;
    float = true;
    position = "top";
    font-size = 11;
  };

  colors = {
    c0 = "2F2F2F"; # black
    c1 = "f7768e"; # red
    c2 = "73daca"; # green
    c3 = "e0af68"; # yellow
    c4 = "4973CB"; # blue
    c5 = "A594FD"; # magenta
    c6 = "7dcfff"; # cyan
    c7 = "FFFFFF"; # white
    c8 = "3F3F3F"; # bright black
    c9 = "f7869e"; # bright red
    c10 = "83eada"; # bright green
    c11 = "f0bf78"; # bright yellow
    c12 = "8ab2f7"; # bright blue
    c13 = "A988F8"; # bright magenta
    c14 = "8ddfff"; # bright cyan
    c15 = "f4f5f7"; # bright white

    bg = "040404";
    fg = "FFFFFF";
    bgalt = "131313";
    fgalt = "f4f5f7";

    accent = "A594FD";
    accentFg = "2F2F2F";

    # Should make those automtic
    accentName = "magenta";
    accentNumber = "5";
  };
}
