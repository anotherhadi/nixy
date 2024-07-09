{ pkgs, ... }: {
  home.packages = with pkgs; [ vimPlugins.neorg ];

  programs.nixvim.plugins = {
    neorg = {
      enable = true;
      modules = {
        "core.defaults" = { __empty = null; };
        "core.dirman" = {
          config = { workspaces = { home = "~/nextcloud/neorg"; }; };
        };
        "core.concealer" = { config.folds = false; };
        "core.export" = { __empty = null; };
        "core.ui.calendar" = { __empty = null; };
        "core.integrations.telescope" = { __empty = null; };
      };
    };
  };

  programs.nixvim.keymaps = [
    {
      key = "<leader>nh";
      action = "<cmd>Telescope neorg search_headings<cr>";
      options.desc = "Neorg Search Headings";
    }
    {
      key = "<leader>nf";
      action = "<cmd>Telescope neorg find_norg_files<cr>";
      options.desc = "Neorg Search Files";
    }
  ];
}
