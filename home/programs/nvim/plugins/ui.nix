{ pkgs, ... }: {
  home.packages = with pkgs; [ ctags ];

  programs.nixvim.plugins = {
    web-devicons.enable = true;
    noice.enable = true;
    gitsigns = {
      enable = true;
      settings.current_line_blame = false;
    };
    trouble.enable = true;
    bufferline.enable = true;
  };
}
