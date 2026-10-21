# Nixy base24 palette, hand-made. Exposed flake-wide as config.theme (modules/theme/default.nix)
{
  base00 = "0A0A0C"; # Default Background
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
  # base24 extension: darker backgrounds and bright variants of the accents (ANSI 9-14)
  base10 = "070709"; # Darker Background
  base11 = "040405"; # Darkest Background
  base12 = "EA8C99"; # Bright Red
  base13 = "D6C47C"; # Bright Yellow
  base14 = "9CCC9C"; # Bright Green
  base15 = "8ECCD3"; # Bright Cyan
  base16 = "B6B0FA"; # Bright Blue
  base17 = "D2AAF0"; # Bright Purple
}
