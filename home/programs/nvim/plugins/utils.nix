{ config, lib, pkgs, ... }: {
  programs.nixvim = {
    nixpkgs.config.allowUnfree = true; # For copilot
    highlightOverride = {
      WhichKeySeparator.bg = "#${config.lib.stylix.colors.base00}";
    };
    plugins = {
      bufferline.enable = true;
      copilot-vim = {
        enable = true;
        settings.node_command = lib.getExe pkgs.nodejs_20;
      };
      flash.enable = true;
      tmux-navigator.enable = true;
      todo-comments.enable = true;
      lualine = { enable = true; };
      aerial.enable = true;
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
    keymaps = [{
      key = "<leader>ct";
      action = "<cmd>AerialToggle<cr>";
      options.desc = "Aerial (tags)";
    }];
  };
}
