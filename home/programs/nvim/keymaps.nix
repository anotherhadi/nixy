{
  programs.nixvim.keymaps = [{
    key = "<space>fm";
    action = "<cmd>lua vim.lsp.buf.format()<cr>";
    options.desc = "LSP Format";
  }];
}
