{
  programs.nixvim.keymaps = [
    {
      key = "<leader>fm";
      action = "<cmd>lua vim.lsp.buf.format()<cr>";
      options.desc = "LSP Format";
    }

    # UI
    {
      key = "<leader>uw";
      action = "<cmd>set wrap!<cr>";
      options.desc = "Toggle word wrapping";
    }
    {
      key = "<leader>uW";
      action = "<cmd>set linebreak!<cr>";
      options.desc = "Toggle linebreak";
    }

    {
      key = "<leader>uz";
      action = "<cmd>ZenMode<cr>";
      options.desc = "Toggle ZenMode";
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
  ];
}
