{ pkgs, inputs, ... }: {
  stylix = {
    enable = true;

    # Edited catppuccin
    base16Scheme = {
      base00 = "0c0e0f"; # Default Background
      base01 =
        "121415"; # Lighter Background (Used for status bars, line number and folding marks)
      base02 = "161819"; # Selection Background
      base03 = "1f2122"; # Comments, Invisibles, Line Highlighting
      base04 = "27292a"; # Dark Foreground (Used for status bars)
      base05 = "edeff0"; # Default Foreground, Caret, Delimiters, Operators
      base06 = "e4e6e7"; # Light Foreground (Not often used)
      base07 = "f2f4f5"; # Light Background (Not often used)
      base08 =
        "f26e74"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
      base09 =
        "ecd28b"; # Integers, Boolean, Constants, XML Attributes, Markup Link Url
      base0A = "e79881"; # Classes, Markup Bold, Search Text Background
      base0B = "82c29c"; # Strings, Inherited Class, Markup Code, Diff Inserted
      base0C =
        "6791c9"; # Support, Regular Expressions, Escape Characters, Markup Quotes
      base0D =
        "709ad2"; # Functions, Methods, Attribute IDs, Headings, Accent color
      base0E =
        "c58cec"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
      base0F =
        "e8646a"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono Nerd Font";
      };
      sansSerif = {
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
        name = "SFProDisplay Nerd Font";
      };
      serif = {
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
        name = "SFProDisplay Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
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
      url =
        "https://github.com/anotherhadi/nixy-wallpapers/blob/main/wallpapers/"
        + "Rocks-misty.png" + "?raw=true";
      sha256 = "sha256-xX/lbesJAxeogKURSlQO65wvMxAnN7KOe3LzZukvFlg=";
    };

  };

}
