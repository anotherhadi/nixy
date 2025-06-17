{
  programs.nvf.settings.vim = {
    viAlias = false;
    vimAlias = true;
    withNodeJs = true;
    # syntaxHighlighting = true;
    options = {
      autoindent = true;
      shiftwidth = 2;
      signcolumn = "yes";
      tabstop = 2;
      softtabstop = 2;
      wrap = false;
    };
    clipboard = {
      enable = true;
      registers = "unnamedplus";
      providers.wl-copy.enable = true;
    };
  };
}
