{ pkgs, ... }: {
  home.packages = with pkgs; [ neofetch ];

  xdg.configFile."neofetch" = {
    recursive = false;
    source = ./config;
  };
}
