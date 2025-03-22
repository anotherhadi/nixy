{ config, ... }: {
  programs.nixvim = {
    plugins.mini = {
      enable = true;
      mockDevIcons = true;
      modules = {
        icons = { };
        # TODO: Learn how to use this
        bracketed = { };
        git = { };
        diff = { };
        starter = { };
        pairs = { };
        notify = { lsp_progress.enable = false; };
        indentscope = { };
        cursorword = { };
        comment = { };
        starter = { };
      };
    };
  };
}
