{ config, ... }: {
  programs.nixvim = {
    plugins.floaterm.enable = true;
    highlightOverride = {
      FloatermBorder.fg = "#${config.lib.stylix.colors.base01}";
    };
    keymaps = [{
      key = "<leader>cn";
      action = "<cmd>FloatermNew --title=nixy nixy || sleep 10<cr>";
      options.desc = "Nixy";
    }];
  };
}
