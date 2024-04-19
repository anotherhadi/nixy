{
  programs.nixvim.plugins.obsidian = {
    enable = true;
    settings = {
      dir = "~/Nextcloud/obsidian";
      disable_frontmatter = true;
    };
  };
}
