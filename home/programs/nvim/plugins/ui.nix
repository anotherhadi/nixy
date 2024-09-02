{ pkgs, config, ... }: {
  home.packages = with pkgs; [ ctags ];

  programs.nixvim = {
    highlight = {
      Headline.bg = "#${config.var.theme.colors.bgalt}";
      Headline.bold = true;
      Headline1.bg = "#${config.var.theme.colors.c0}";
      Headline1.bold = true;
    };
    plugins = {
      lualine.enable = true;
      noice.enable = true;
      gitsigns = {
        enable = true;
        settings.current_line_blame = false;
      };
      bufferline.enable = true;
      trouble.enable = true;
      indent-blankline.enable = true;
      which-key.enable = true;
      headlines = {
        enable = true;
        settings = {
          markdown = {
            headline_highlights = [ "Headline1" "Headline" ];
            fat_headlines = false;
            bullets = [ "" "◉" "○" "✸" ];
            dash_string = "";
            codeblock_highlight = "Headline";
          };
        };
      };
      nvim-colorizer.enable = true;
      tagbar.enable = true; # FIXME: Tagbar is not working
    };
    keymaps = [{
      key = "<leader>t";
      action = "<cmd>TroubleToggle<cr>";
      options.desc = "Trouble";
    }];
  };
}
