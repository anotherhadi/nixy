{
  programs.nixvim.keymaps = [
    {
      key = "<leader>e";
      action = "<CMD>Neotree toggle<CR>";
      options.desc = "Neotree Toggle";
    }
    {
      key = "<space>fm";
      action = "<CMD>lua vim.lsp.buf.format()<CR>";
      options.desc = "LSP Format";
    }
    {
      key = "<leader>ox";
      action = "vip:!pandoc -t commonmark_x<cr>";
      options.desc = "Format Markdown Tables";
    }
    {
      key = "<leader>ot";
      action = "<cmd>lua require('obsidian').util.toggle_checkbox()<cr>";
      options.desc = "Toggle Checkbox";
    }

    {
      key = "<leader>oo";
      action = "<cmd>ObsidianQuickSwitch<cr>";
      options.desc = "Quick Switch";
    }

    {
      key = "<leader>on";
      action = "<cmd>ObsidianNew<cr>";
      options.desc = "New";
    }

    {
      key = "<leader>of";
      action = "<cmd>ObsidianSearch<cr>";
      options.desc = "Search";
    }

    {
      key = "<leader>oi";
      action = "<cmd>ObsidianPasteImg<cr>";
      options.desc = "Paste Image";
    }

    {
      key = "<leader>E";
      action = "<cmd>Oil<cr>";
      options.desc = "Oil";
    }

    {
      key = "<leader>t";
      action = "<cmd>TroubleToggle<cr>";
      options.desc = "Trouble";
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

    # Terminal Mappings
    {
      mode = "t";
      key = "<esc>";
      action = "<C-\\><C-n>";
    }
  ];
}
