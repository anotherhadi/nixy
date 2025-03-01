{ pkgs, ... }: {
  home.packages = with pkgs; [ ctags ];

  programs.nixvim.plugins = {
    trouble.enable = true;
    lazygit.enable = true;
  };
}
