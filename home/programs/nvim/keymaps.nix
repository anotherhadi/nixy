{
  programs.nixvim.keymaps = [
    {
      key = "<leader>fm";
      action = "<cmd>lua vim.lsp.buf.format()<cr>";
      options.desc = "LSP Format";
    }
    {
      key = "<leader>w";
      action = "<cmd>set wrap!<cr>";
      options.desc = "Toggle word wrapping";
    }
    {
      key = "<leader>W";
      action = "<cmd>set linebreak!<cr>";
      options.desc = "Toggle linebreak";
    }
  ];
}
