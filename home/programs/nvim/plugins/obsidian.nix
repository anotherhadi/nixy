{ config, ... }: {
  programs.nixvim.plugins.obsidian = {
    enable = config.var.obsidian;
    settings = {
      completion = {
        min_chars = 2;
        nvim_cmp = true;
      };
      disable_frontmatter = true;
      workspaces = [{
        name = "note";
        path = "~/nextcloud/Notes";
      }];
    };
  };
}
