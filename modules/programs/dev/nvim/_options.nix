{
  vim = {
    viAlias = false;
    vimAlias = true;
    options = {
      smartindent = true;
      shiftwidth = 2;
      foldlevel = 99;
      foldcolumn = "auto:1";
      mousescroll = "ver:1,hor:1";
      fillchars = "eob:‿,fold: ,foldopen:▼,foldsep:⸽,foldclose:⏵";
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
