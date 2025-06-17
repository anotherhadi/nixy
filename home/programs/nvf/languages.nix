{
  programs.nvf.settings.vim = {
    diagnostics = {
      enable = true;
      nvim-lint.enable = true;
      config.virtual_text = true;
    };
    syntaxHighlighting = true;
    treesitter = {
      enable = true;
      autotagHtml = true;
      context.enable = true;
      highlight = {
        enable = true;
        additionalVimRegexHighlighting = true;
      };
    };
    lsp = {
      enable = true;
      trouble.enable = true;
      formatOnSave = true;
      inlayHints.enable = true;
      lightbulb.enable = true;
      null-ls.enable = true;
      otter-nvim.enable = true;
    };
    languages = {
      enableDAP = true;
      enableExtraDiagnostics = true;
      enableFormat = true;
      enableTreesitter = true;

      astro.enable = true;
      go.enable = true;
      markdown.enable = true;
      ts.enable = true;
      ts.extensions.ts-error-translator.enable = true;
      css.enable = true;
      svelte.enable = true;
      html.enable = true;
      bash.enable = true;
      nix.enable = true;
      tailwind.enable = true;
    };
  };
}
