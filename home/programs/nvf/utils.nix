{pkgs, ...}: {
  vim = {
    luaConfigRC.remove-todo-keymaps = ''
      vim.keymap.del("n", "<leader>tdq")
      vim.keymap.del("n", "<leader>tdt")
    '';
    undoFile.enable = true;
    notes.todo-comments.enable = true;
    assistant.copilot = {
      enable = true;
      cmp.enable = true;
    };

    autocomplete = {
      nvim-cmp = {
        enable = true;
        sources = {
          buffer = "[Buffer]";
          path = "[Path]";
        };
        sourcePlugins = [
          pkgs.vimPlugins.cmp-cmdline
        ];
      };
    };

    snippets.luasnip.enable = true;
    ui = {
      noice.enable = true;
      colorizer.enable = true;
    };

    visuals = {
      rainbow-delimiters.enable = true;
    };

    extraPlugins = {
      sttr-nvim = {
        package = pkgs.vimUtils.buildVimPlugin {
          name = "sttr-nvim";
          src = pkgs.fetchFromGitHub {
            owner = "anotherhadi";
            repo = "sttr.nvim";
            rev = "b41f2f51372222e23efbe5df9d72391cd933d4d1";
            hash = "sha256-JPv0NNNUUNPNJM5LHYjcmTvilbOKB3OxI2Q6wxVbTks=";
          };
        };
        setup = ''
          require("sttr").setup()
        '';
      };
      jwt-tui-nvim = {
        package = pkgs.vimUtils.buildVimPlugin {
          name = "jwt-tui-nvim";
          src = pkgs.fetchFromGitHub {
            owner = "anotherhadi";
            repo = "jwt-tui.nvim";
            rev = "c5100cb2cdfaf333014076a1a5c4c6a778bf3983";
            hash = "sha256-qnQYZuQwyWkezhuyOorM67KBtatUboubofuT9A6McJI=";
          };
        };
        setup = ''
          require("jwt-tui").setup()
        '';
      };
    };
  };
}
