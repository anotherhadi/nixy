{
  programs.nixvim.keymaps = [
    {
      key = "<leader>e";
      action = "<CMD>Neotree toggle<CR>";
    }
    {
      key = "<space>fm";
      action = "<CMD>lua vim.lsp.buf.format()<CR>";
    }

    {
      key = "<leader>ot";
      action = "<cmd>lua require('obsidian').util.toggle_checkbox()<cr>";
    }

    {
      key = "<leader>oo";
      action = "<cmd>ObsidianQuickSwitch<cr>";
    }

    {
      key = "<leader>on";
      action = "<cmd>ObsidianNew<cr>";
    }

    {
      key = "<leader>of";
      action = "<cmd>ObsidianSearch<cr>";
    }

    {
      key = "<leader>oi";
      action = "<cmd>ObsidianPasteImg<cr>";
    }

    {
      key = "<leader>E";
      action = "<cmd>Oil<cr>";
    }

    {
      key = "<leader>t";
      action = "<cmd>TroubleToggle<cr>";
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
