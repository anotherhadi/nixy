{ config, ... }: {
  programs.nixvim = {
    highlightOverride = {
      FloatBorder.fg = "#${config.lib.stylix.colors.base0D}";
    };
    nixpkgs.config = { allowUnfree = true; };
    plugins = {
      copilot-vim.enable = true;
      flash.enable = true;
      tmux-navigator.enable = true;
      comment.enable = true;
      nvim-autopairs.enable = true;
      todo-comments.enable = true;
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
