{
  vim.utility.snacks-nvim = {
    enable = true;
    setupOpts = {
      quickfile.enabled = true;
      statuscolumn.enabled = true;
      zen.enabled = true;
      bufdelete.enabled = true;
      gitsigns.enabled = true;
      animate.enabled = true;
      lazygit = {
        enabled = true;
        configure = false;
      };
      terminal.enabled = true;
    };
  };
}
