{
  wallpaper = "nix.png";

  font = "SFProDisplay Nerd Font";
  font-mono = "FiraCode Nerd Font Mono";
  font-size = 13;

  rounding = 11;
  gaps-in = 15;
  gaps-out = 15 * 2;
  border-size = 5;
  animation-speed = "medium"; # "fast" | "medium" | "slow"
  fetch = "neofetch"; # "nerdfetch" | "neofetch" | "pfetch" | "none"

  waybar = {
    transparent = true;
    float = true;
    position = "top";
    font-size = 15;
  };

  colors = {
    c0 = "1e1e2e"; # black
    c1 = "f38ba8"; # red
    c2 = "a6e3a1"; # green
    c3 = "fab387"; # yellow
    c4 = "89b4fa"; # blue
    c5 = "cba6f7"; # magenta
    c6 = "74c7ec"; # cyan
    c7 = "cdd6f4"; # white
    c8 = "313244"; # bright black
    c9 = "eba0ac"; # bright red
    c10 = "94e2d5"; # bright green
    c11 = "f9e2af"; # bright yellow
    c12 = "b4befe"; # bright blue
    c13 = "f5c2e7"; # bright magenta
    c14 = "94e2d5"; # bright cyan
    c15 = "bac2de"; # bright white

    bg = "01010b";
    fg = "cdd6f4";
    bgalt = "181825";
    fgalt = "bac2de";

    accent = "89b4fa";
    accentFg = "1e1e2e";

    # Should make those automtic
    accentName = "blue";
    accentNumber = "4";
  };
}
