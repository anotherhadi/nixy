{ config, ... }: {
  programs.nixvim = {
    nixpkgs.config.allowUnfree = true; # For copilot
    highlightOverride = {
      WhichKeySeparator.bg = "#${config.lib.stylix.colors.base00}";
    };
    plugins = {
      bufferline.enable = true;
      copilot-vim.enable = true;
      flash.enable = true;
      tmux-navigator.enable = true;
      todo-comments.enable = true;
      lualine = { enable = true; };
      treesitter = {
        enable = true;
        nixGrammars = true;
        settings = {
          ensure_installed = "all";
          indent.enable = true;
          highlight.enable = true;
        };
      };
    };
  };
}
