{
  programs.nixvim = {
    plugins = {
      neo-tree.enable = true;
      oil = {
        enable = true;
        settings = { 
          default_file_explorer = false;
          skip_confirm_for_simple_edits = true;
        };
      };
    };
    keymaps = [
      {
        key = "-";
        action = "<cmd>Oil<cr>";
        options.desc = "Oil";
      }
      {
        key = "<leader>e";
        action = "<cmd>Oil --float<cr>";
        options.desc = "Oil";
      }
      {
        key = "<leader>E";
        action = "<cmd>Neotree toggle<cr>";
        options.desc = "Neotree";
      }
    ];
  };
}
