{
  vim = {
    viAlias = false;
    vimAlias = true;
    options = {
      smartindent = true;
      shiftwidth = 2;
      foldlevel = 99;
      foldcolumn = "auto:1";
      mousescroll = "ver:1,hor:1";
      fillchars = "eob:‿,fold: ,foldopen:▼,foldsep:⸽,foldclose:⏵";
      signcolumn = "yes";
      tabstop = 2;
      softtabstop = 2;
      wrap = false;
    };
    clipboard = {
      enable = true;
      registers = "unnamedplus";
    };
    luaConfigRC.osc52-clipboard = ''
      vim.g.clipboard = {
        name = 'OSC 52',
        copy = {
          ['+'] = require('vim.ui.clipboard.osc52').copy '+',
          ['*'] = require('vim.ui.clipboard.osc52').copy '*',
        },
        paste = {
          ['+'] = require('vim.ui.clipboard.osc52').paste '+',
          ['*'] = require('vim.ui.clipboard.osc52').paste '*',
        },
      }
    '';
  };
}
