{ pkgs, config, ... }: {
  wayland.windowManager.hyprland.settings.exec-once =
    [ "${pkgs.hyprpanel}/bin/hyprpanel" ];

  home.packages = with pkgs; [ hyprpanel ];
}
