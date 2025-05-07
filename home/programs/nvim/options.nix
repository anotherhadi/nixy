{
  programs.nixvim = {
    globals.mapleader = " ";
    diagnostic.settings = {
      virtual_text = true;
      virtual_improved = { current_line = "only"; };
    };
    opts = {
      autoindent = true;

      smartindent = true;

      incsearch = true;
      hlsearch = true;
      wildmode = "list:longest";
      scrolloff = 8;

      swapfile = false;
      conceallevel = 3;
      clipboard = "unnamed,unnamedplus";

      # Don't stop backspace at insert
      backspace.__raw = ''
        vim.list_extend(vim.opt.backspace:get(), { "nostop" })
      '';

      # Keep visual indentation on wrapped lines
      breakindent = true;

      # Hide command line unless needed
      cmdheight = 0;

      # Insert mode completion options
      completeopt = [ "menu" "menuone" "noselect" ];

      # Raise a dialog asking if you wish to save the current file(s)
      confirm = true;

      # Copy previous indentation on autoindenting
      copyindent = true;

      # Highlight current line
      cursorline = true;

      # Expand <Tab> to spaces
      expandtab = true;

      # Disable `~` on nonexistent lines
      fillchars = { eob = " "; };

      # Enable fold with all code unfolded
      foldcolumn = "1";
      foldenable = true;
      foldlevel = 99;
      foldlevelstart = 99;

      # Ignore case in search patterns
      ignorecase = true;

      # Show substitution preview in split window
      inccommand = "split";

      # Infer casing on word completion
      infercase = true;

      # Global statusline
      laststatus = 3;

      # Wrap lines at 'breakat'
      linebreak = true;

      # Enable mouse support
      mouse = "a";

      # Show line numbers
      number = true;

      # Preserve indentation as much as possible
      preserveindent = true;

      # Height of the popup menu
      pumheight = 10;

      # Display line numbers relative to current line
      relativenumber = true;

      # Minimal number of lines to keep around the cursor
      # This has the effect to move the view along with current line
      #scrolloff = 999;

      # Number of spaces to use for indentation
      shiftwidth = 2;

      # Disable showing modes in command line
      showmode = false;

      # Always show tabline
      showtabline = 2;

      # Show signs column
      signcolumn = "yes";

      # Override ignorecase if search pattern contains uppercase characters
      smartcase = true;

      # Number of spaces input on <Tab>
      softtabstop = 2;

      # Open horizontal split below (:split)
      splitbelow = true;

      # Open vertical split to the right (:vsplit)
      splitright = true;

      # Number of spaces to represent a <Tab>
      tabstop = 2;

      # Enables 24-bit RGB color
      termguicolors = true;

      # Shorter timeout duration
      timeoutlen = 500;

      # Set window title to the filename
      title = true;

      # Save undo history to undo file (in $XDG_STATE_HOME/nvim/undo)
      undofile = true;

      # Enable virtual edit in visual block mode
      # This has the effect of selecting empty cells beyond lines boundaries
      virtualedit = "block";

      # Disable line wrapping
      wrap = false;

      # Disable making a backup before overwriting a file
      writebackup = false;
    };
  };
}
