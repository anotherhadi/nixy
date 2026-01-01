{
  lib,
  pkgs,
  config,
  ...
}: {
  options.theme = lib.mkOption {
    type = lib.types.attrs;
    default = {
      rounding = 30;
      gaps-in = 12;
      gaps-out = 12 * 2;
      active-opacity = 0.96;
      inactive-opacity = 0.94;
      blur = true;
      border-size = 4;
      animation-speed = "fast"; # "fast" | "medium" | "slow"
      fetch = "none"; # "nerdfetch" | "neofetch" | "pfetch" | "none"
      textColorOnWallpaper =
        config.lib.stylix.colors.base00; # Color of the text displayed on the wallpaper (Lockscreen, display manager, ...)
    };
    description = "Theme configuration options";
  };

  config.stylix = {
    enable = true;

    # See https://tinted-theming.github.io/tinted-gallery/ for more schemes
    base16Scheme = {
      base00 = "151320"; # Default Background
      base01 = "1f1d2e"; # Lighter Background (Used for status bars, line number and folding marks)
      base02 = "26233a"; # Selection Background
      base03 = "6e6a86"; # Comments, Invisibles, Line Highlighting
      base04 = "908caa"; # Dark Foreground (Used for status bars)
      base05 = "e0def4"; # Default Foreground, Caret, Delimiters, Operators
      base06 = "e0def4"; # Light Foreground (Not often used)
      base07 = "524f67"; # Light Background (Not often used)
      base08 = "eb6f92"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
      base09 = "f6c177"; # Integers, Boolean, Constants, XML Attributes, Markup Link Url
      base0A = "ebbcba"; # Classes, Markup Bold, Search Text Background
      base0B = "31748f"; # Strings, Inherited Class, Markup Code, Diff Inserted
      base0C = "9ccfd8"; # Support, Regular Expressions, Escape Characters, Markup Quotes
      base0D = "c4a7e7"; # Functions, Methods, Attribute IDs, Headings, Accent color
      base0E = "f6c177"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
      base0F = "524f67"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    };

    cursor = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 20;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono Nerd Font";
      };
      sansSerif = {
        package = pkgs.source-sans-pro;
        name = "Source Sans Pro";
      };
      serif = config.stylix.fonts.sansSerif;
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 13;
        desktop = 13;
        popups = 13;
        terminal = 13;
      };
    };

    polarity = "dark";
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/anotherhadi/awesome-wallpapers/refs/heads/main/app/static/wallpapers/pink-clouds.png";
      sha256 = "sha256-IvINf62mg9rKjml4sh8hl/j7UHrQQlbm6QnZTaI+TRk=";
    };
  };
}
