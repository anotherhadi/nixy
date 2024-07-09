{

  programs.nixvim.globals.mapleader = " ";
  programs.nixvim.opts = {
    updatetime = 50; # Faster completion

    number = true;
    relativenumber = true;

    autoindent = true;
    clipboard = "unnamed,unnamedplus";

    expandtab = true;
    tabstop = 2;
    softtabstop = 2;
    shiftwidth = 2;
    smartindent = true;
    breakindent = true;

    ignorecase = true;
    incsearch = true;
    hlsearch = true;
    smartcase = true;
    wildmode = "list:longest";
    completeopt = [ "menuone" "noselect" ];
    signcolumn = "yes";
    cursorline = false;
    scrolloff = 8;
    mouse = "a";

    wrap = false;

    swapfile = false;
    undofile = true;
    conceallevel = 3;
  };
}
