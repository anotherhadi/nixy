{
  lib,
  pkgs,
  config,
  ...
}: {
  options.theme = lib.mkOption {
    type = lib.types.attrs;
    default = {
      rounding = 28;
      bar-rounding = 28 + 10;
      bar-thickness = 0;
      gaps-in = 10;
      gaps-out = 10 * 2;
      active-opacity = 0.98;
      inactive-opacity = 0.95;
      blur = true;
      border-size = 4;
      animation-speed = "medium"; # "fast" | "medium" | "slow"
      fetch = "none"; # "nerdfetch" | "neofetch" | "pfetch" | "none"
    };
    description = "Theme configuration options";
  };

  config.stylix = {
    enable = true;

    # See https://tinted-theming.github.io/tinted-gallery/ for more schemes
    base16Scheme = {
      base00 = "0B0B0D"; # Default Background
      base01 = "110F12"; # Lighter Background (Used for status bars, line number and folding marks)
      base02 = "2D2A36"; # Selection Background
      base03 = "514D63"; # Comments, Invisibles, Line Highlighting
      base04 = "8E8AA0"; # Dark Foreground (Used for status bars)
      base05 = "C2BED6"; # Default Foreground, Caret, Delimiters, Operators
      base06 = "D8D5EA"; # Light Foreground (Not often used)
      base07 = "EAE7F7"; # Light Background (Not often used)
      base08 = "E07080"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
      base09 = "D49070"; # Integers, Boolean, Constants, XML Attributes, Markup Link Url
      base0A = "C4B060"; # Classes, Markup Bold, Search Text Background
      base0B = "80B880"; # Strings, Inherited Class, Markup Code, Diff Inserted
      base0C = "70B8C0"; # Support, Regular Expressions, Escape Characters, Markup Quotes
      base0D = "9E97F8"; # Functions, Methods, Attribute IDs, Headings, Accent color
      base0E = "C090E8"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
      base0F = "D080A0"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
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
      url = "https://raw.githubusercontent.com/anotherhadi/awesome-wallpapers/refs/heads/main/app/static/wallpapers/a-violet-blur.png";
      sha256 = "sha256-uzAhuKGqnN038A5P+xdvxYgRiYq046GDmD9P1FcISz4=";
    };
  };
}
