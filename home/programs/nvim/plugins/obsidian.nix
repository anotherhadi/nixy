{ config, ... }: {
  programs.nixvim.plugins.obsidian = {
    enable = config.var.obsidian;
    settings = {
      dir = "~/nextcloud/Notes";
      disable_frontmatter = true;
    };
  };
}
