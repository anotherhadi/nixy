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
      };
    };
  };
}
