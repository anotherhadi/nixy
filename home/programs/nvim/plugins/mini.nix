{ config, ... }: {
  programs.nixvim = {
    plugins.mini = {
      enable = true;
      mockDevIcons = true;
      modules = {
        icons = { };
        # TODO: Learn how to use this
        bracketed = { };
        tabline = { };
        statusline = { };
        starter = { };
        pairs = { };
        notify = { lsp_progress.enable = false; };
        indentscope = { };
        git = { };
        cursorword = { };
        comment = { };
        starter = { };
      };
    };
  };
}
