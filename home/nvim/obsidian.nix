{
  programs.nixvim.plugins.obsidian = {
    enable = true;
    settings = {
      dir = "~/Nextcloud/obsidian";
      disableFrontmatter = true;
    };
  };
}
