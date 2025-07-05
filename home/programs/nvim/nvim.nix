{ config, lib, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      onedark-nvim
      lualine-nvim
      bufferline-nvim
      nvim-tree-lua
      telescope-nvim
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      (nvim-treesitter.withPlugins (plugins: [
        plugins.tree-sitter-python
        plugins.tree-sitter-rust
        plugins.tree-sitter-javascript
        plugins.tree-sitter-typescript
        plugins.tree-sitter-html
        plugins.tree-sitter-css
        plugins.tree-sitter-json
        plugins.tree-sitter-lua
        plugins.tree-sitter-nix
        plugins.tree-sitter-cpp
        plugins.tree-sitter-bash
        plugins.tree-sitter-markdown
      ]))
      nvim-autopairs
      comment-nvim
      which-key-nvim
      indent-blankline-nvim
    ];

    extraLuaConfig = ''
      vim.opt.termguicolors = true
      require('onedark').setup({
        style = 'dark',
        highlights = {
          LineNr = { fg = '#5c6370', bg = 'none' }, 
          CursorLineNr = { fg = '#e5c07b', bg = 'none' }, 
        }
      })
      vim.cmd.colorscheme("onedark")
      
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.smartindent = true
      vim.opt.signcolumn = "yes"
      vim.opt.updatetime = 300
      vim.g.mapleader = ' '

      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
      vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
      
      vim.api.nvim_set_hl(0, "VertSplit", { bg = "none", fg = "#3b4252" })
      vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none", fg = "#3b4252" })

      require("bufferline").setup({
        highlights = {
          fill = { bg = "none" },
          background = { bg = "none" },
          tab = { bg = "none" },
          tab_selected = { bg = "none" },
          tab_close = { bg = "none" },
          separator = { fg = "#3b4252", bg = "none" },
          separator_selected = { fg = "#3b4252", bg = "none" },
          separator_visible = { fg = "#3b4252", bg = "none" },
          indicator_selected = { fg = "#61afef", bg = "none" },
        },
        options = {
          mode = "tabs",
          separator_style = "slant",
          always_show_bufferline = true,
          show_close_icon = false,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left"
            }
          }
        }
      })

      require('lualine').setup({
        options = {
          theme = 'onedark',
          component_separators = "",
          section_separators = "",
          globalstatus = true
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'filename'},
          lualine_c = {'diagnostics'},
          lualine_x = {'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
      })

    '';
    
    extraConfig = ''
      set scrolloff=8
      set mouse=a
      set clipboard=unnamedplus
      set undofile
      set undodir=~/.vim/undodir
      set noswapfile
      
      highlight LineNr guibg=NONE
      highlight CursorLineNr guibg=NONE
      
      set fillchars=vert:│
      highlight VertSplit gui=NONE cterm=NONE
      
      autocmd BufWritePre *.py,*.rs,*.js,*.ts,*.lua,*.nix,*.cpp,*.c lua vim.lsp.buf.format()
    '';
  };
}
