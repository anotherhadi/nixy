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
      blur = false;
      border-size = 4;
      animation-speed = "medium"; # "fast" | "medium" | "slow"
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
      base00 = "090E13"; # Default Background
      base01 = "12171E"; # Lighter Background (Used for status bars, line number and folding marks)
      base02 = "393B44"; # Selection Background
      base03 = "54546D"; # Comments, Invisibles, Line Highlighting
      base04 = "A4A7A4"; # Dark Foreground (Used for status bars)
      base05 = "C5C9C7"; # Default Foreground, Caret, Delimiters, Operators
      base06 = "DCD7BA"; # Light Foreground (Not often used)
      base07 = "C8C093"; # Light Background (Not often used)
      base08 = "C4746E"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
      base09 = "B6927B"; # Integers, Boolean, Constants, XML Attributes, Markup Link Url
      base0A = "C4B28A"; # Classes, Markup Bold, Search Text Background
      base0B = "8A9A7B"; # Strings, Inherited Class, Markup Code, Diff Inserted
      base0C = "8EA4A2"; # Support, Regular Expressions, Escape Characters, Markup Quotes
      base0D = "8BA4B0"; # Functions, Methods, Attribute IDs, Headings, Accent color
      base0E = "A292A3"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
      base0F = "B98D7B"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    };

    cursor = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 20;
    };

    fonts = {
      monospace = {
        package = pkgs.maple-mono.NF;
        name = "Maple Mono NF";
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
      url = "https://raw.githubusercontent.com/anotherhadi/awesome-wallpapers/refs/heads/main/app/static/wallpapers/rain-pixel.png";
      sha256 = "sha256-f4ZWb4nKCNP1aanTJ5EI0nI7Vpvd+Mp79JFL708qPR4=";
    };
  };
}
