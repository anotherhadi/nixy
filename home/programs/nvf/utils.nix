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
  };
}
