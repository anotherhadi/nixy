{ pkgs, config, ... }: {
  home.packages = with pkgs; [ hyprpaper ];

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/.config/wallpapers/${config.theme.wallpaper}
    wallpaper = ,~/.config/wallpapers/${config.theme.wallpaper}
    ipc=true
    splash=false
  '';
}
