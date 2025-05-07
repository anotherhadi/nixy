{
  programs.nixvim.plugins = {
    lsp-format.enable = true;
    lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        bashls.enable = true;
        gopls.enable = true;
        ts_ls.enable = true;
        nixd.enable = true;
        tailwindcss.enable = true;
        html.enable = true;
        svelte.enable = true;
        astro.enable = true;
      };
    };
    none-ls = {
      enable = true;
      sources = {
        completion = { luasnip.enable = true; };
        diagnostics = {
          golangci_lint.enable = true;
          statix.enable = true;
        };
        formatting = {
          gofmt.enable = true;
          goimports.enable = true;
          nixfmt.enable = true;
          markdownlint.enable = true;
          tidy.enable = true;
          shellharden.enable = true;
          shfmt.enable = true;
          golines.enable = true;
          gofumpt.enable = true;
        };
      };
    };
  };
}
