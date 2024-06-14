{ config, ... }: {
  imports = [ ../shared/variables-config.nix ];

  config.var = {
    hostname = "nixy";
    username = "hadi";
    homeDirectory = "/home/" + config.var.username;

    keyboardLayout = "fr";

    timeZone = "Europe/Paris";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "fr_FR.UTF-8";

    git = {
      username = "Hadi";
      email = "112569860+anotherhadi@users.noreply.github.com";
    };

    stateVersion = "24.05";

    autoUpgrade = false;
    autoGarbageCollector = false;
    sops = true;
    nextcloud = true;
    nvidia = true;
    nvidiaPrime = true;

    theme = {
      wallpaper = "Lofi-Computer.png";

      font-mono = "FiraCode Nerd Font Mono";
      font = "SFProDisplay Nerd Font";

      rounding = 15;
      gaps-in = 12;
      gaps-out = config.var.theme.gaps-in * 2;
      border-size = 4;

      fetch = "nerdfetch"; # "nerdfetch" | "neofetch" | "none"

      waybar = {
        transparent = true;
        float = true;
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
        fg = config.var.theme.colors.c7;
        bgalt = "131313";
        fgalt = config.var.theme.colors.c15;

        accent = config.var.theme.colors.c4;
        accentFg = config.var.theme.colors.c0;

        # Should make those automtic
        accentName = "blue";
        accentNumber = "4";
      };
    };
  };
}
