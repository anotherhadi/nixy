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
      };
    };
  };
}
