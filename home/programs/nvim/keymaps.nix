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
      options.desc = "Toggle Word Wrapping";
    }
  ];
}
