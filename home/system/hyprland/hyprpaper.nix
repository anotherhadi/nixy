{ pkgs, config, ... }: {
  # wayland.windowManager.hyprland.settings.exec-once =
  #   [ "${pkgs.hyprpaper}/bin/hyprpaper" ];

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;
      preload = [ "~/wallpapers/${config.var.theme.wallpaper}" ];
      wallpaper = [ ",~/wallpapers/${config.var.theme.wallpaper}" ];
    };
  };
}
