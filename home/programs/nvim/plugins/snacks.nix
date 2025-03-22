{
  programs.nixvim = {
    plugins.snacks = {
      enable = true;
      settings = {
        image = {
          enable = true;
          doc = { inline = false; };
        };
        quickfile.enable = true;
        statuscolumn.enable = true;
        zen.enable = true;
        bufdelete.enable = true;
      };
    };

    keymaps = [
      {
        key = "<leader>uz";
        action = "<cmd>lua Snacks.zen()<cr>";
        options.desc = "Zen";
      }
      {
        key = "<leader>ud";
        action = "<cmd>lua Snacks.dim.enable()<cr>";
        options.desc = "Dim";
      }
      {
        key = "<leader>uD";
        action = "<cmd>lua Snacks.dim.disable()<cr>";
        options.desc = "Undim";
      }
      {
        key = "<leader>wc";
        action = "<cmd>lua Snacks.bufdelete.all()<cr>";
        options.desc = "Close all buffers";
      }
    ];
  };
}
