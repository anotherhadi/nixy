{ config, ... }: {
  programs.nixvim = {
    highlight = {
      TelescopePromptPrefix.fg = "#${config.lib.stylix.colors.base0D}";
      TelescopeSelectionCaret = {
        fg = "#${config.lib.stylix.colors.base0D}";
        bg = "#${config.lib.stylix.colors.base01}";
      };
      TelescopeSelection.bg = "#${config.lib.stylix.colors.base01}";
      TelescopePromptTitle = {
        bg = "#${config.lib.stylix.colors.base00}";
        fg = "#${config.lib.stylix.colors.base0D}";
      };
      TelescopePromptNormal.bg = "#${config.lib.stylix.colors.base00}";
      TelescopePromptBorder = {
        bg = "#${config.lib.stylix.colors.base00}";
        fg = "#${config.lib.stylix.colors.base0D}";
      };
    };
    plugins.telescope = {
      enable = true;
      extensions.fzf-native = { enable = true; };
      settings.defaults = { selection_caret = "❚ "; };
    };
  };
}
