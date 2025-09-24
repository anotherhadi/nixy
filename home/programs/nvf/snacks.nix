{
  programs.nvf.settings.vim.utility.snacks-nvim = {
    enable = true;
    setupOpts = {
      image = {
        enabled = true;
        doc = {
          inline = false;
          float = true;
        };
      };
      quickfile.enabled = true;
      statuscolumn.enabled = true;
      zen.enabled = true;
      bufdelete.enabled = true;
      gitsigns.enabled = true;
    };
  };
}
