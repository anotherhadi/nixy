{
  programs.nvf.settings = {
    vim = {
      snippets.luasnip = {
        enable = true;
        setupOpts = {
          update_events = "TextChanged,TextChangedI";
          store_selection_keys = "<Tab>";
          delete_check_events = "TextChanged";
          enable_autosnippets = true;
          history = false;
        };
      };

      lazy.plugins.luasnip.event = "BufEnter";

      keymaps = [
        {
          mode = "i";
          key = "<tab>";
          lua = true;
          expr = true;
          action = # lua
            ''
              function()
                local ls = require("luasnip")
                if ls.expand_or_locally_jumpable() then
                  vim.schedule(function()
                    ls.expand_or_jump()
                  end)
                  return "<ignore>"
                else
                  return vim.api.nvim_replace_termcodes("<tab>", true, true, true)
                end
              end
            '';
        }
        {
          mode = "i";
          key = "<S-tab>";
          lua = true;
          action = # lua
            ''
              function()
                local ls = require("luasnip")
                if ls.jumpable(-1) then
                  vim.schedule(function()
                    ls.jump(-1)
                  end)
                end
              end
            '';
        }
      ];
    };
  };
}
