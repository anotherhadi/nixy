{
  lib,
  pkgs,
  config,
  ...
}: {
  options.theme = lib.mkOption {
    type = lib.types.attrs;
    default = {
      rounding = 15;
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
      base00 = "000000"; # Default Background
      base01 = "121212"; # Lighter Background (Used for status bars, line number and folding marks)
      base02 = "222222"; # Selection Background
      base03 = "333333"; # Comments, Invisibles, Line Highlighting
      base04 = "999999"; # Dark Foreground (Used for status bars)
      base05 = "c1c1c1"; # Default Foreground, Caret, Delimiters, Operators
      base06 = "999999"; # Light Foreground (Not often used)
      base07 = "c1c1c1"; # Light Background (Not often used)
      base08 = "5f8787"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
      base09 = "aaaaaa"; # Integers, Boolean, Constants, XML Attributes, Markup Link Url
      base0A = "79241f"; # Classes, Markup Bold, Search Text Background
      base0B = "f8f7f2"; # Strings, Inherited Class, Markup Code, Diff Inserted
      base0C = "aaaaaa"; # Support, Regular Expressions, Escape Characters, Markup Quotes
      base0D = "888888"; # Functions, Methods, Attribute IDs, Headings, Accent color
      base0E = "999999"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
      base0F = "444444"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
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
      url = "https://images.hdqwalls.com/wallpapers/anime-asian-wing-girl-4k-06.jpg";
      sha256 = "sha256-Ku/bfeeXZ3kpjS8Ew1TFnHypjFVTZOVGW/EmV/+DaTU=";
    };
  };
}
