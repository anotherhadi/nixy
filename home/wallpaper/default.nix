{ config, ... }: {
  xdg.configFile."wallpaper" = {
    recursive = true;
    source = ./wallpaper;
  };
}
