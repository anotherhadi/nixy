{
  programs.nixvim.plugins = {
    zen-mode = {
      enable = true;
      settings = {
        on_close = ''
          function()
            require("gitsigns.actions").toggle_current_line_blame()
            vim.cmd('IBLEnable')
            vim.opt.signcolumn = "yes:2"
            vim.wo.wrap = false
            vim.wo.linebreak = false
            require("gitsigns.actions").refresh()
          end
        '';
        on_open = ''
          function()
            require("gitsigns.actions").toggle_current_line_blame()
            vim.cmd('IBLDisable')
            vim.opt.relativenumber = false
            vim.opt.signcolumn = "no"
            vim.wo.wrap = true
            vim.wo.linebreak = true
            require("gitsigns.actions").refresh()
          end
        '';
        window = {
          backdrop = 1;
          height = 1;
          options = {
            signcolumn = "no";
            number = false;
            relativenumber = false;
            cursorline = false;
            cursorcolumn = false;
            foldcolumn = "0";
            list = false;
          };
          width = 0.8;

        };
      };
    };

  };
}
