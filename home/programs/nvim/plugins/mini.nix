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
        notify = { };
        indentscope = { };
        git = { };
        cursorword = { };
        comment = {
          mappings = {
            comment = "<leader>/";
            comment_line = "<leader>/";
            comment_visual = "<leader>/";
            textobject = "<leader>/";
          };
        };
        starter = { };
      };
    };
  };
}
