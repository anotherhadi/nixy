{
  programs.nvf.settings = {
    vim = {
      useSystemClipboard = true;

      options = {
        # 2-space indents
        tabstop = 2;
        softtabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        autoindent = true;
        smartindent = true;
        breakindent = true;

        # Searching
        hlsearch = true;
        incsearch = true;
        ignorecase = true;
        smartcase = true;

        # Splitting
        splitbelow = true;
        splitright = true;

        # Undo
        undofile = true;
        undolevels = 10000;
        swapfile = false;
        backup = false;

        # Disable folding
        foldlevel = 99;
        foldlevelstart = 99;

        # Misc
        termguicolors = true;
        timeoutlen = 1000;
        preserveindent = true;
        showmode = false;
        scrolloff = 4;
        conceallevel = 3;
        cmdheight = 0;
        sidescrolloff = 4;
        cursorline = true;
        linebreak = true;
        wrap = false;
        writebackup = false;
        encoding = "utf-8";
        fileencoding = "utf-8";
        signcolumn = "yes";
        fillchars = "eob: "; # Disable the "~" chars at end of buffer
      };

      globals = {
        tex_flavor = "latex";
      };
    };
  };
}
