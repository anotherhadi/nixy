{ config, ... }: {
  programs.nixvim = {
    highlightOverride = {
      FloatBorder.fg = "#${config.var.theme.colors.accent}";
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
        keymaps = {
          "<leader>fg" = "live_grep";
          "<leader> " = "find_files";
        };
        extensions.fzf-native = { enable = true; };
      };
      treesitter = {
        enable = true;
        nixGrammars = true;
        settings.indent.enable = true;
      };
      treesitter-context.enable = true;
    };
    keymaps = [
      {
        key = "<C-h>";
        action = "<cmd>TmuxNavigateLeft<cr>";
      }
      {
        key = "<C-j>";
        action = "<cmd>TmuxNavigateDown<cr>";
      }
      {
        key = "<C-k>";
        action = "<cmd>TmuxNavigateUp<cr>";
      }
      {
        key = "<C-l>";
        action = "<cmd>TmuxNavigateRight<cr>";
      }
    ];
  };
}
