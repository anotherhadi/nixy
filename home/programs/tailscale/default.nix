{ pkgs, ... }: {
  home.packages = with pkgs; [ tailscale tailscale-systray ];

  wayland.windowManager.hyprland.settings.exec-once =
    [ "${pkgs.tailscale-systray}/bin/tailscale-systray" ];
}
