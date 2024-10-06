{ config, ... }: {
  programs.nixvim = {
    highlightOverride = {
      FloatBorder.fg = "#${config.lib.stylix.colors.base0D}";
    };
    plugins = {
      copilot-vim.enable = true;
      flash.enable = true;
      # image.enable = true;
      tmux-navigator.enable = true;
      comment.enable = true;
      nvim-autopairs.enable = true;
      friendly-snippets.enable = true;
      telescope = {
        enable = true;
        extensions.fzf-native = { enable = true; };
      };
      todo-comments.enable = true;
      treesitter = {
        enable = true;
        nixGrammars = true;
        settings = {
          indent.enable = true;
          highlight.enable = true;
        };
      };
      treesitter-context.enable = true;
    };
  };
}
