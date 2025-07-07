{ config, lib, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      onedark-nvim
      cord-nvim
      lualine-nvim
      bufferline-nvim
      nvim-tree-lua
      nvim-web-devicons
      telescope-nvim
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      lspkind-nvim
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

      vim.keymap.set("n", "<C-n>",     ":NvimTreeToggle<CR>")
      vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>")
      vim.keymap.set("n", "<leader>bd", ":bd<CR>") 
      vim.keymap.set("n", "<leader>bo", ":%bd|e#|bd#<CR>")
      vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
      vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
      vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
      vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>")

      require("bufferline").setup({
        options = {
          numbers = "ordinal",        
          closable = true,             
          close_icon = '',            
          left_trunc_marker = '',     
          right_trunc_marker = '',    
          indicator = {
            style = 'underline',       
            icon = '▎',
          },
          tab_size = 18,
          max_name_length = 18,
          max_prefix_length = 15,
          offsets = {
            {
              filetype = "NvimTree",
              text = "Explorer",
              text_align = "center",
              separator = true,
            },
          },
          diagnostics = "nvim_lsp",    
          diagnostics_update_in_insert = false,
          diagnostic_indicator = function(count, level)
          local icon = level:match("error") and " "
                    or level:match("warn")  and " "
                    or level:match("info")  and " "
                    or " "
          return icon .. count
          end,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          persist_buffer_sort = true,
          separator_style = "thin",     
          enforce_regular_tabs = false,
          always_show_bufferline = true,
        },
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

      require("nvim-tree").setup({
	      disable_netrw = true,
		    hijack_netrw = true,
		    open_on_tab = false,
		    update_cwd = true,
		    diagnostics = {
				  enable = true,
				  icons = { hint = "", info = "", warning = "", error = "" },
		    },
		    filters = { dotfiles = false, custom = { "node_modules", ".cache" } },
      })

      require("telescope").setup({
	      defaults = {
	        prompt_prefix = "❯ ",
				  selection_caret = "❯ ",
				  path_display = { "smart" },
				  file_ignore_patterns = { "node_modules", ".git/" },
				  mappings = {
						i = {
								["<C-j>"] = require("telescope.actions").move_selection_next,
								["<C-k>"] = require("telescope.actions").move_selection_previous,
								["<C-c>"] = require("telescope.actions").close,
						},
						n = {
								["q"] = require("telescope.actions").close,
						},
				  },
		    },
		    pickers = {
				  find_files = { theme = "dropdown", hidden = true },
				  live_grep = { theme = "dropdown" },
				  buffers = { theme = "dropdown", sort_lastused = true },
				  help_tags = { theme = "dropdown" },
		    },
		    extensions = {
				  fzf = {
						  fuzzy = true,
						  override_generic_sorter = true,
						  override_file_sorter    = true,
						  case_mode = "smart_case",
				  },
		    },
      })

      require("nvim-web-devicons").setup({
		    default = true,
		    color_icons = true,
		    safe = true,
		    override = {
				  [".gitignore"] = { icon = "", color = "#f1502f", name = "GitIgnore" },
				  ["Dockerfile"] = { icon = "", color = "#384d54", name = "Dockerfile" },
				  ["Makefile"] = { icon = "", color = "#6d8086", name = "Makefile" },
				  ["README.md"] = { icon = "", color = "#6d8086", name = "ReadmeMd" },
				  ["LICENSE"] = { icon = "", color = "#cbcb41", name = "License" },
		    },
		    override_by_extension = {
				  ["lua"] = { icon = "", color = "#51a0cf", name = "Lua" },
				  ["js"] = { icon = "", color = "#f1e05a", name = "JS" },
				  ["ts"] = { icon = "", color = "#2b7489", name = "TS" },
				  ["jsx"] = { icon = "", color = "#61dafb", name = "JSX" },
				  ["tsx"] = { icon = "", color = "#61dafb", name = "TSX" },
				  ["css"] = { icon = "", color = "#563d7c", name = "CSS" },
				  ["html"] = { icon = "", color = "#e34c26", name = "HTML" },
				  ["json"] = { icon = "", color = "#cbcb41", name = "JSON" },
				  ["md"] = { icon = "", color = "#519aba", name = "Markdown" },
				  ["py"] = { icon = "", color = "#3572A5", name = "Python" },
				  ["go"] = { icon = "", color = "#00ADD8", name = "Go" },
				  ["rs"] = { icon = "", color = "#dea584", name = "Rust" },
				  ["yml"] = { icon = "", color = "#cb171e", name = "YAML" },
				  ["toml"] = { icon = "", color = "#9c4221", name = "TOML" },
				  ["lock"] = { icon = "", color = "#ccb29b", name = "Lock" },
				  ["env"] = { icon = "", color = "#ffffff", name = "Env" },
				  ["sh"] = { icon = "", color = "#89e051", name = "Shell" },
				  ["zsh"] = { icon = "", color = "#89e051", name = "Zsh" },
				  ["bash"] = { icon = "", color = "#89e051", name = "Bash" },
				  ["Dockerfile"] = { icon = "", color = "#384d54", name = "Dockerfile" },
				  ["yarn.lock"] = { icon = "", color = "#2c8ebb", name = "YarnLock" },
				  ["package.json"] = { icon = "", color = "#cbcb41", name = "PackageJSON" },
		    },
		    override_by_filename = {
				  [".bashrc"] = { icon = "", color = "#89e051", name = "Bashrc" },
				  [".zshrc"] = { icon = "", color = "#89e051", name = "Zshrc" },
				  [".gitconfig"] = { icon = "", color = "#f1502f", name = "GitConfig" },
				  [".prettierrc"] = { icon = "", color = "#f7b93e", name = "PrettierConfig" },
				  [".eslintrc.js"] = { icon = "", color = "#4b32c3", name = "EslintConfig" },
		    },
	    })
      
        require("cmp").setup({
          snippet = {
            expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end
          },
          mapping = require("cmp").mapping.preset.insert({
            ["<C-Space>"] = require("cmp").mapping.complete(),
            ["<CR>"] = require("cmp").mapping.confirm({ select = true }),
            ["<Tab>"] = require("cmp").mapping.select_next_item(),
            ["<S-Tab>"] = require("cmp").mapping.select_prev_item()
          }),
          sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" }
          },
          formatting = {
            format = require("lspkind").cmp_format({
            with_text = true,
            maxwidth = 50,
            menu = {
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              buffer = "[Buf]",
              path = "[Path]"
            }
          })
        },
        window = {
          completion = require("cmp").config.window.bordered(),
          documentation = require("cmp").config.window.bordered()
        }
      })

      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        check_ts = true,
        ts_config = {
          lua = {"string"},
          javascript = {"template_string"},
          typescript = {"template_string"},
          vue = {"template_string"},
        }
      })

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
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

