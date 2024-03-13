{ pkgs, config, ... }: {
  home.packages = with pkgs; [ hyprpaper ];

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/.config/wallpaper/${config.theme.wallpaper}
    wallpaper = ,~/.config/wallpaper/${config.theme.wallpaper}
    ipc=true
    splash=false
  '';
}
