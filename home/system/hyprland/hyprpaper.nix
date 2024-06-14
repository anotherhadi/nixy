{ pkgs, config, ... }: {
  home.packages = with pkgs; [ hyprpaper ];

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/wallpapers/${config.var.theme.wallpaper}
    wallpaper = ,~/wallpapers/${config.var.theme.wallpaper}
    ipc=true
    splash=false
  '';
}
