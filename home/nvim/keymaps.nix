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

    # Terminal Mappings
    {
      mode = "t";
      key = "<esc>";
      action = "<C-\\><C-n>";
    }
  ];
}
