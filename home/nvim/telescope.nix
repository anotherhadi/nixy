{
  programs.nixvim.plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader>fg" = "live_grep";
      "<C-p>" = {
        action = "git_files";
        desc = "Telescope Git Files";
      };
    };
    extensions.fzf-native = { enable = true; };
  };
}
