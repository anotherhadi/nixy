{
  programs.nixvim.plugins.obsidian = {
    enable = true;
    settings = {
      dir = "~/nextcloud/Notes";
      disable_frontmatter = true;
    };
  };
}
