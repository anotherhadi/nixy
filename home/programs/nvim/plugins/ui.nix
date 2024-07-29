{ pkgs, ... }: {
  home.packages = with pkgs; [ ctags ];
  programs.nixvim = {
    plugins = {
      lualine.enable = true;
      noice.enable = true;
      gitsigns = {
        enable = true;
        settings.current_line_blame = false;
      };
      bufferline.enable = true;
      trouble.enable = true;
      which-key.enable = true;
      headlines = {
        enable = true;
        settings = {
          markdown = {
            codeblock_highlight = false;
          };
        };
      };
      nvim-colorizer.enable = true;
      # tagbar.enable = true;
    };
    keymaps = [{
      key = "<leader>t";
      action = "<cmd>TroubleToggle<cr>";
      options.desc = "Trouble";
    }];
  };
}
