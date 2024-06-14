{
  programs.nixvim.plugins.none-ls = {
    enable = true;
    sources = {
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
      };
    };
  };
}
