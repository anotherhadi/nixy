{ config, ... }: {
  programs.nixvim = {
    highlightOverride = {
      SnacksPicker = {
        bg = "none";
        nocombine = true;
      };
      SnacksPickerBorder = {
        bg = "none";
        fg = "#${config.lib.stylix.colors.base0D}";
      };
      SnacksPickerTree = { bg = "#${config.lib.stylix.colors.base00}"; };
      FloatBorder = {
        bg = "#${config.lib.stylix.colors.base00}";
        fg = "#${config.lib.stylix.colors.base0D}";
      };
      NormalFloat = { bg = "#${config.lib.stylix.colors.base00}"; };
    };
    plugins = {
      snacks.settings = {
        picker.enable = true;
        explorer.enable = true;
      };
      oil.enable = true;
      which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>f";
          mode = "n";
          group = "+find";
        }
        {
          __unkeyed-1 = "<leader>g";
          mode = "n";
          group = "+git";
        }
        {
          __unkeyed-1 = "<leader>s";
          mode = "n";
          group = "+search";
        }
      ];
    };
    keymaps = [
      # Top Pickers & Explorer
      {
        key = "<leader> ";
        action = "<cmd>lua Snacks.picker.smart()<cr>";
        options.desc = "Smart Find Files";
      }
      {
        key = "<leader>,";
        action = "<cmd>lua Snacks.picker.buffers()<cr>";
        options.desc = "Buffers";
      }
      {
        key = "<leader>/";
        action = "<cmd>lua Snacks.picker.grep()<cr>";
        options.desc = "Grep";
      }
      {
        key = "<leader>:";
        action = "<cmd>lua Snacks.picker.command_history()<cr>";
        options.desc = "Command History";
      }
      {
        key = "<leader>e";
        action = "<cmd>lua Snacks.explorer()<cr>";
        options.desc = "File Explorer";
      }
      {
        key = "-";
        action = "<cmd>Oil<cr>";
        options.desc = "Oil";
      }

      # Find
      {
        key = "<leader>fb";
        action = "<cmd>lua Snacks.picker.buffers()<cr>";
        options.desc = "Buffers";
      }
      {
        key = "<leader>fc";
        action = ''
          <cmd>lua Snacks.picker.files({ cwd = vim.fn.stdpath("config") })<cr>'';
        options.desc = "Find Config File";
      }
      {
        key = "<leader>ff";
        action = "<cmd>lua Snacks.picker.files()<cr>";
        options.desc = "Find Files";
      }
      {
        key = "<leader>fg";
        action = "<cmd>lua Snacks.picker.git_files()<cr>";
        options.desc = "Find Git Files";
      }
      {
        key = "<leader>fp";
        action = "<cmd>lua Snacks.picker.projects()<cr>";
        options.desc = "Projects";
      }
      {
        key = "<leader>fr";
        action = "<cmd>lua Snacks.picker.recent()<cr>";
        options.desc = "Recent";
      }
      {
        key = "<leader>fn";
        action = "<cmd>lua Snacks.picker.notifications()<cr>";
        options.desc = "Notification History";
      }
      {
        key = "<leader>fe";
        action = "<cmd>lua Snacks.picker.icons()<cr>";
        options.desc = "Emoji";
      }

      # Git
      {
        key = "<leader>gb";
        action = "<cmd>lua Snacks.picker.git_branches()<cr>";
        options.desc = "Git Branches";
      }
      {
        key = "<leader>gL";
        action = "<cmd>lua Snacks.picker.git_log()<cr>";
        options.desc = "Git Log Line";
      }
      {
        key = "<leader>gs";
        action = "<cmd>lua Snacks.picker.git_status()<cr>";
        options.desc = "Git Status";
      }
      {
        key = "<leader>gS";
        action = "<cmd>lua Snacks.picker.git_stash()<cr>";
        options.desc = "Git Stash";
      }
      {
        key = "<leader>gd";
        action = "<cmd>lua Snacks.picker.git_diff()<cr>";
        options.desc = "Git Diff (Hunks)";
      }
      {
        key = "<leader>gf";
        action = "<cmd>lua Snacks.picker.git_log_file()<cr>";
        options.desc = "Git Log File";
      }

      # Grep
      {
        key = "<leader>sb";
        action = "<cmd>lua Snacks.picker.lines()<cr>";
        options.desc = "Buffer Lines";
      }
      {
        key = "<leader>st";
        action = "<cmd>lua Snacks.picker.todo_comments()<cr>";
        options.desc = "Todos";
      }
      {
        key = "<leader>sB";
        action = "<cmd>lua Snacks.picker.grep_buffers()<cr>";
        options.desc = "Grep Open Buffers";
      }
      {
        key = "<leader>sg";
        action = "<cmd>lua Snacks.picker.grep()<cr>";
        options.desc = "Grep";
      }
      {
        key = "<leader>sw";
        action = "<cmd>lua Snacks.picker.grep_word()<cr>";
        options.desc = "Visual selection or word";
      }
      {
        key = "<leader>sr";
        action = "<cmd>nohlsearch<cr>";
        options.desc = "Reset search";
      }

      # LSP
      {
        key = "gd";
        action = "<cmd>lua Snacks.picker.lsp_definitions()<cr>";
        options.desc = "Goto Definition";
      }
      {
        key = "gD";
        action = "<cmd>lua Snacks.picker.lsp_declarations()<cr>";
        options.desc = "Goto Declaration";
      }
      {
        key = "gr";
        action = "<cmd>lua Snacks.picker.lsp_references()<cr>";
        options.desc = "References";
        options.nowait = true;
      }
      {
        key = "gI";
        action = "<cmd>lua Snacks.picker.lsp_implementations()<cr>";
        options.desc = "Goto Implementation";
      }
      {
        key = "gy";
        action = "<cmd>lua Snacks.picker.lsp_type_definitions()<cr>";
        options.desc = "Goto Type Definition";
      }
      {
        key = "<leader>ss";
        action = "<cmd>lua Snacks.picker.lsp_symbols()<cr>";
        options.desc = "LSP Symbols";
      }
      {
        key = "<leader>sS";
        action = "<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>";
        options.desc = "LSP Workspace Symbols";
      }
    ];
  };
}
