{ config, ... }: {
  programs.nixvim = {
    nixpkgs.config.allowUnfree = true; # For copilot
    highlightOverride = {
      FloatBorder.fg = "#${config.lib.stylix.colors.base0D}";
    };
    plugins = {
      copilot-vim.enable = true;
      flash.enable = true;
      tmux-navigator.enable = true;
      treesitter = {
        enable = true;
        nixGrammars = true;
        settings = {
          ensure_installed = "all";
          indent.enable = true;
          highlight.enable = true;
        };
      };
    };
  };
}
