{
  vim.utility.snacks-nvim = {
    enable = true;
    setupOpts = {
      quickfile.enabled = true;
      statuscolumn.enabled = true;
      zen.enabled = true;
      bufdelete.enabled = true;
      lazygit = {
        enabled = true;
        configure = false;
      };
      terminal.enabled = true;
    };
  };
}
