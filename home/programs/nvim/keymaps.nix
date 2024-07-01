{
  programs.nixvim.keymaps = [
    {
      key = "<space>fm";
      action = "<cmd>lua vim.lsp.buf.format()<cr>";
      options.desc = "LSP Format";
    }
    {
      key = "<space>ft";
      action = "vip:!pandoc -t commonmark_x<cr>";
      options.desc = "Format markdown table";
    }
  ];
}
