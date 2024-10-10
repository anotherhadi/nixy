{
  programs.nixvim = {
    plugins.which-key = {
      enable = true;
      settings = {
        delay = 600;
        icons = {
          breadcrumb = "»";
          group = "+";
          separator = ""; # ➜
          mappings = false;
        };
        spec = [
          # General Mappings
          {
            __unkeyed-1 = "<leader>c";
            mode = [ "n" "v" ];
            group = "+code";
          }
          {
            __unkeyed-1 = "<leader>d";
            mode = [ "n" "v" ];
            group = "+debug";
          }
          {
            __unkeyed-1 = "<leader>s";
            mode = "n";
            group = "+search";
          }
          {
            __unkeyed-1 = "<leader>m";
            mode = "n";
            group = "+markdown";
          }
          {
            __unkeyed-1 = "<leader>t";
            mode = "n";
            group = "+trouble";
          }
          {
            __unkeyed-1 = "<leader>u";
            mode = "n";
            group = "+ui";
          }
          {
            __unkeyed-1 = "<leader>w";
            mode = "n";
            group = "+windows";
          }
          {
            __unkeyed-1 = "<leader>h";
            mode = "n";
            group = "+harpoon";
          }
        ];
        win = {
          border = "rounded";
          wo.winblend = 0;
        };
      };
    };

    keymaps = [
      # General Mappings
      {
        key = "<leader>e";
        action = "<cmd>Oil --float<cr>";
        options.desc = "Oil";
      }
      {
        key = "-";
        action = "<cmd>Oil<cr>";
        options.desc = "Oil";
      }
      {
        key = "<leader>E";
        action = "<cmd>Neotree toggle<cr>";
        options.desc = "Neotree";
      }

      {
        key = "s";
        action = "<cmd>lua require('flash').jump()<cr>";
        options.desc = "Flash";
      }
      {
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<cr>";
        options.desc = "LSP Hover";
      }

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

      # UI
      {
        key = "<leader>uz";
        action = "<cmd>ZenMode<cr>";
        options.desc = "Toggle ZenMode";
      }
      {
        key = "<leader>uw";
        action = "<cmd>set wrap!<cr>";
        options.desc = "Toggle word wrapping";
      }
      {
        key = "<leader>ul";
        action = "<cmd>set linebreak!<cr>";
        options.desc = "Toggle linebreak";
      }
      {
        key = "<leader>us";
        action = "<cmd>set spell!<cr>";
        options.desc = "Toggle spellcheck";
      }
      {
        key = "<leader>uc";
        action = "<cmd>set cursorline!<cr>";
        options.desc = "Toggle cursorline";
      }
      {
        key = "<leader>un";
        action = "<cmd>set number!<cr>";
        options.desc = "Toggle line numbers";
      }
      {
        key = "<leader>ur";
        action = "<cmd>set relativenumber!<cr>";
        options.desc = "Toggle relative line numbers";
      }
      {
        key = "<leader>ut";
        action = "<cmd>set showtabline=2<cr>";
        options.desc = "Show tabline";
      }
      {
        key = "<leader>uT";
        action = "<cmd>set showtabline=0<cr>";
        options.desc = "Hide tabline";
      }

      # Search
      {
        key = "<leader> ";
        action = "<cmd>lua require('telescope.builtin').find_files()<cr>";
        options.desc = "Telescope";
      }
      {
        key = "<leader>sg";
        action = "<cmd>lua require('telescope.builtin').live_grep()<cr>";
        options.desc = "Livegrep";
      }
      {
        key = "<leader>sf";
        action = "<cmd>lua require('telescope.builtin').find_files()<cr>";
        options.desc = "Find Files";
      }
      {
        key = "<leader>sb";
        action = "<cmd>lua require('telescope.builtin').buffers()<cr>";
        options.desc = "Buffers";
      }
      {
        key = "<leader>sh";
        action = "<cmd>lua require('telescope.builtin').help_tags()<cr>";
        options.desc = "Help Tags";
      }
      {
        key = "<leader>sc";
        action = "<cmd>lua require('telescope.builtin').commands()<cr>";
        options.desc = "Commands";
      }
      {
        key = "<leader>sm";
        action = "<cmd>lua require('telescope.builtin').marks()<cr>";
        options.desc = "Marks";
      }
      {
        key = "<leader>so";
        action = "<cmd>lua require('telescope.builtin').oldfiles()<cr>";
        options.desc = "Oldfiles";
      }
      {
        key = "<leader>ss";
        action = "<cmd>lua require('telescope.builtin').spell_suggest()<cr>";
        options.desc = "Spell Suggest";
      }
      {
        key = "<leader>sr";
        action = "<cmd>:noh<return><esc>";
        options.desc = "Reset search";
      }
      {
        key = "<leader>st";
        action = "<cmd>TodoTelescope<cr>";
        options.desc = "Todos";
      }

      # Trouble
      {
        key = "<leader>tx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Diagnostics (Trouble)";
      }
      {
        key = "<leader>tX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        options.desc = "Buffer Diagnostics (Trouble)";
      }
      {
        key = "<leader>ts";
        action = "<cmd>Trouble symbols toggle focus=false<cr>";
        options.desc = "Symbols (Trouble)";
      }
      {
        key = "<leader>tl";
        action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
        options.desc = "LSP Definitions / references / ... (Trouble)";
      }
      {
        key = "<leader>tL";
        action = "<cmd>Trouble loclist toggle<cr>";
        options.desc = "Location List (Trouble)";
      }
      {
        key = "<leader>tQ";
        action = "<cmd>Trouble qflist toggle<cr>";
        options.desc = "Quickfix List (Trouble)";
      }

      # Windows
      {
        key = "<leader>ws";
        action = "<cmd>split<cr>";
        options.desc = "Split";
      }
      {
        key = "<leader>wv";
        action = "<cmd>vsplit<cr>";
        options.desc = "VSplit";
      }
      {
        key = "<leader>wd";
        action = "<cmd>close<cr>";
        options.desc = "Close";
      }

      # Code
      {
        key = "<leader>cd";
        action = "<cmd>lua vim.lsp.buf.definition()<cr>";
        options.desc = "LSP Definition";
      }
      {
        key = "<leader>cr";
        action = "<cmd>lua vim.lsp.buf.references()<cr>";
        options.desc = "LSP References";
      }
      {
        key = "<leader>ct";
        action = "<cmd>lua vim.lsp.buf.type_definition()<cr>";
        options.desc = "LSP Type Definition";
      }
      {
        key = "<leader>ca";
        action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
        options.desc = "LSP Code Action";
      }
      {
        key = "<leader>cf";
        action = "<cmd>lua vim.lsp.buf.formatting()<cr>";
        options.desc = "LSP Formatting";
      }
      {
        key = "<leader>cn";
        action = "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>";
        options.desc = "LSP Next Diagnostic";
      }
      {
        key = "<leader>cp";
        action = "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>";
        options.desc = "LSP Previous Diagnostic";
      }
      {
        key = "<leader>cu";
        action = "<cmd>lua require('dapui').toggle()<CR>";
        options.desc = "Toggle Dapui";
      }
      {
        key = "<leader>cb";
        action = "<cmd>lua require('dap').toggle_breakpoint()<CR>";
        options.desc = "Toggle breakpoint";
      }
    ];
  };
}
