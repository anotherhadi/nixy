{ config, ... }: {
  xdg.configFile."wallpapers" = {
    recursive = true;
    source = ./wallpapers;
  };
}
