{ lib, pkgs, inputs, ... }: {

  options.theme = lib.mkOption {
    type = lib.types.attrs;
    default = {
      rounding = 10;
      gaps-in = 10;
      gaps-out = 10 * 2;
      active-opacity = 0.98;
      inactive-opacity = 0.96;
      blur = true;
      border-size = 3;
      animation-speed = "medium"; # "fast" | "medium" | "slow"
      fetch = "none"; # "nerdfetch" | "neofetch" | "pfetch" | "none"

      bar = { # Hyprpanel
        position = "top"; # "top" | "bottom"
        transparent = true;
        transparentButtons = false;
        floating = true;
      };
    };
    description = "Theme configuration options";
  };

  config = {
    stylix = {
      enable = true;

      # See https://tinted-theming.github.io/tinted-gallery/ for more schemes
      base16Scheme = {
        base00 = "0c0e0f"; # Default Background
        base01 =
          "202324"; # Lighter Background (Used for status bars, line number and folding marks)
        base02 = "313244"; # Selection Background
        base03 = "45475a"; # Comments, Invisibles, Line Highlighting
        base04 = "585b70"; # Dark Foreground (Used for status bars)
        base05 = "cdd6f4"; # Default Foreground, Caret, Delimiters, Operators
        base06 = "f5e0dc"; # Light Foreground (Not often used)
        base07 = "b4befe"; # Light Background (Not often used)
        base08 =
          "f38ba8"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
        base09 =
          "fab387"; # Integers, Boolean, Constants, XML Attributes, Markup Link Url
        base0A = "f9e2af"; # Classes, Markup Bold, Search Text Background
        base0B =
          "a6e3a1"; # Strings, Inherited Class, Markup Code, Diff Inserted
        base0C =
          "94e2d5"; # Support, Regular Expressions, Escape Characters, Markup Quotes
        base0D =
          "89b4fa"; # Functions, Methods, Attribute IDs, Headings, Accent color
        base0E =
          "cba6f7"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
        base0F =
          "f2cdcd"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
      };

      cursor = {
        name = "phinger-cursors-light";
        package = pkgs.phinger-cursors;
        size = 20;
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
          "https://raw.githubusercontent.com/Keyitdev/sddm-astronaut-theme/refs/heads/master/Backgrounds/pixel_sakura_static.png";
        sha256 = "sha256-y6AJu7RXnI5vPLPVts6tflb9XukDkgiL+J6vUPj4lbs=";
      };
    };
  };

}
