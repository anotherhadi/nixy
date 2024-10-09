{ config, ... }:
let
  accent = "#${config.lib.stylix.colors.base0D}";
  background = "#${config.lib.stylix.colors.base00}";
  background-alt = "#${config.lib.stylix.colors.base01}";
in {
  programs.nixvim = {
    highlight = {
      TelescopePromptPrefix.fg = accent;
      TelescopeSelectionCaret = {
        fg = accent;
        bg = background-alt;
      };
      TelescopeSelection.bg = background-alt;
      TelescopePromptTitle = {
        bg = background;
        fg = accent;
      };
      TelescopePromptNormal.bg = background;
      TelescopePromptBorder = {
        bg = background;
        fg = accent;
      };
    };
    plugins.telescope = {
      enable = true;
      extensions.fzf-native = { enable = true; };
      settings.defaults = { selection_caret = "❚ "; };
    };
  };
}
