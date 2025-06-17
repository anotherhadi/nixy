{
  programs.nvf.settings.vim = {
    utility = {
      oil-nvim.enable = true;
      snacks-nvim = {
        setupOpts = {
          picker.enabled = true;
          explorer.enabled = true;
        };
      };
    };
    keymaps = [
      # Top Pickers & Explorer
      {
        key = "<leader> ";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.smart()<cr>";
        desc = "Smart Find Files";
      }
      {
        key = "<leader>,";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.buffers()<cr>";
        desc = "Buffers";
      }
      {
        key = "<leader>/";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.grep()<cr>";
        desc = "Grep";
      }
      {
        key = "<leader>:";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.command_history()<cr>";
        desc = "Command History";
      }
      {
        key = "<leader>e";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.explorer()<cr>";
        desc = "File Explorer";
      }
      {
        key = "-";
        mode = "n";
        silent = true;
        action = "<cmd>Oil<cr>";
        desc = "Oil";
      }

      # Find
      {
        key = "<leader>fb";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.buffers()<cr>";
        desc = "Buffers";
      }
      {
        key = "<leader>fc";
        mode = "n";
        silent = true;
        action = ''
          <cmd>lua Snacks.picker.files({ cwd = vim.fn.stdpath("config") })<cr>'';
        desc = "Find Config File";
      }
      {
        key = "<leader>ff";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.files()<cr>";
        desc = "Find Files";
      }
      {
        key = "<leader>fg";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.git_files()<cr>";
        desc = "Find Git Files";
      }
      {
        key = "<leader>fp";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.projects()<cr>";
        desc = "Projects";
      }
      {
        key = "<leader>fr";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.recent()<cr>";
        desc = "Recent";
      }
      {
        key = "<leader>fn";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.notifications()<cr>";
        desc = "Notification History";
      }
      {
        key = "<leader>fe";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.icons()<cr>";
        desc = "Emoji";
      }

      # Git
      {
        key = "<leader>gb";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.git_branches()<cr>";
        desc = "Git Branches";
      }
      {
        key = "<leader>gL";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.git_log()<cr>";
        desc = "Git Log Line";
      }
      {
        key = "<leader>gs";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.git_status()<cr>";
        desc = "Git Status";
      }
      {
        key = "<leader>gS";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.git_stash()<cr>";
        desc = "Git Stash";
      }
      {
        key = "<leader>gd";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.git_diff()<cr>";
        desc = "Git Diff (Hunks)";
      }
      {
        key = "<leader>gf";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.git_log_file()<cr>";
        desc = "Git Log File";
      }

      # Grep
      {
        key = "<leader>sb";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.lines()<cr>";
        desc = "Buffer Lines";
      }
      {
        key = "<leader>st";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.todo_comments()<cr>";
        desc = "Todos";
      }
      {
        key = "<leader>sB";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.grep_buffers()<cr>";
        desc = "Grep Open Buffers";
      }
      {
        key = "<leader>sg";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.grep()<cr>";
        desc = "Grep";
      }
      {
        key = "<leader>sw";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.grep_word()<cr>";
        desc = "Visual selection or word";
      }
      {
        key = "<leader>sr";
        mode = "n";
        silent = true;
        action = "<cmd>nohlsearch<cr>";
        desc = "Reset search";
      }

      # LSP
      {
        key = "gd";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.lsp_definitions()<cr>";
        desc = "Goto Definition";
      }
      {
        key = "gD";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.lsp_declarations()<cr>";
        desc = "Goto Declaration";
      }
      {
        key = "gr";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.lsp_references()<cr>";
        desc = "References";
        nowait = true;
      }
      {
        key = "gI";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.lsp_implementations()<cr>";
        desc = "Goto Implementation";
      }
      {
        key = "gy";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.lsp_type_definitions()<cr>";
        desc = "Goto Type Definition";
      }
      {
        key = "<leader>ss";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.lsp_symbols()<cr>";
        desc = "LSP Symbols";
      }
      {
        key = "<leader>sS";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>";
        desc = "LSP Workspace Symbols";
      }
    ];
  };
}
