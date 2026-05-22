{
  vim = {
    globals.mapleader = " ";
    keymaps = [
      {
        key = "s";
        mode = "n";
        silent = true;
        action = "<cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.single_character)<cr>";
        desc = "Jump2d";
      }
      {
        key = "K";
        mode = "n";
        silent = true;
        action = "<cmd>lua vim.lsp.buf.hover()<cr>";
        desc = "LSP Hover";
      }
      {
        key = "<C-tab>";
        mode = "n";
        silent = true;
        action = "<cmd>bnext<cr>";
        desc = "Next Buffer";
      }

      # Format
      {
        key = "<leader>lf";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('conform').format({ async = true, lsp_format = 'fallback' })<cr>";
        desc = "Format file";
      }

      # Terminal
      {
        key = "<leader>tt";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.terminal.toggle()<cr>";
        desc = "Toggle terminal";
      }
      {
        key = "<leader>tf";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.terminal.toggle(nil, { style = 'float' })<cr>";
        desc = "Toggle terminal (float)";
      }
      {
        key = "<leader>tg";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.lazygit()<cr>";
        desc = "Lazygit";
      }
      {
        key = "<leader>ts";
        mode = "v";
        silent = true;
        action = ":<C-u>SttrTransform<CR>";
        desc = "String Transform";
      }

      # UI
      {
        key = "<leader>uw";
        mode = "n";
        silent = true;
        action = "<cmd>set wrap!<cr>";
        desc = "Toggle word wrapping";
      }
      {
        key = "<leader>ul";
        mode = "n";
        silent = true;
        action = "<cmd>set linebreak!<cr>";
        desc = "Toggle linebreak";
      }
      {
        key = "<leader>us";
        mode = "n";
        silent = true;
        action = "<cmd>set spell!<cr>";
        desc = "Toggle spellLazyGitcheck";
      }
      {
        key = "<leader>uc";
        mode = "n";
        silent = true;
        action = "<cmd>set cursorline!<cr>";
        desc = "Toggle cursorline";
      }
      {
        key = "<leader>un";
        mode = "n";
        silent = true;
        action = "<cmd>set number!<cr>";
        desc = "Toggle line numbers";
      }
      {
        key = "<leader>ur";
        mode = "n";
        silent = true;
        action = "<cmd>set relativenumber!<cr>";
        desc = "Toggle relative line numbers";
      }
      {
        key = "<leader>ut";
        mode = "n";
        silent = true;
        action = "<cmd>set showtabline=2<cr>";
        desc = "Show tabline";
      }
      {
        key = "<leader>uT";
        mode = "n";
        silent = true;
        action = "<cmd>set showtabline=0<cr>";
        desc = "Hide tabline";
      }

      # Todos
      {
        key = "<leader>xt";
        mode = "n";
        silent = true;
        action = "<cmd>TodoTrouble<cr>";
        desc = "Todo (Trouble)";
      }

      # QOL
      {
        key = ">";
        mode = "v";
        silent = true;
        action = ">gv";
        desc = "Indent and keep selection";
      }
      {
        key = "<";
        mode = "v";
        silent = true;
        action = "<gv";
        desc = "Dedent and keep selection";
      }

      # Move
      {
        key = "<C-h>";
        mode = "n";
        silent = true;
        action = "<C-w>h";
        desc = "Move to left window";
      }
      {
        key = "<C-j>";
        mode = "n";
        silent = true;
        action = "<C-w>j";
        desc = "Move to bottom window";
      }
      {
        key = "<C-k>";
        mode = "n";
        silent = true;
        action = "<C-w>k";
        desc = "Move to top window";
      }
      {
        key = "<C-l>";
        mode = "n";
        silent = true;
        action = "<C-w>l";
        desc = "Move to right window";
      }

      # Save
      {
        key = "<C-s>";
        mode = [
          "n"
          "i"
          "v"
        ];
        silent = true;
        action = "<cmd>w<cr>";
        desc = "Save file";
      }

      # Deactivate "esc"
      {
        key = "<Esc>";
        mode = [
          "n"
          "i"
          "v"
        ];
        silent = true;
        action = "<Nop>";
        desc = "Disable Escape";
      }

      # Disable Arrow Keys in Normal Mode and Middle click
      {
        key = "<Up>";
        mode = "n";
        silent = true;
        action = "<Nop>";
        desc = "Disable Up Arrow";
      }
      {
        key = "<Down>";
        mode = "n";
        silent = true;
        action = "<Nop>";
        desc = "Disable Down Arrow";
      }
      {
        key = "<Left>";
        mode = "n";
        silent = true;
        action = "<Nop>";
        desc = "Disable Left Arrow";
      }
      {
        key = "<Right>";
        mode = "n";
        silent = true;
        action = "<Nop>";
        desc = "Disable Right Arrow";
      }
      {
        key = "<MiddleMouse>";
        mode = [
          "n"
          "i"
          "v"
        ];
        action = "<nop>";
        silent = true;
      }
      {
        key = "<2-MiddleMouse>";
        mode = [
          "n"
          "i"
          "v"
        ];
        action = "<nop>";
        silent = true;
      }
      {
        key = "<3-MiddleMouse>";
        mode = [
          "n"
          "i"
          "v"
        ];
        action = "<nop>";
        silent = true;
      }
    ];
  };
}
