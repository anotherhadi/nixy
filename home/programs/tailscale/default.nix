# Tailscale is a VPN service that works on top of WireGuard.
# It allows me to access my servers and devices from anywhere.
{pkgs, ...}: {
  home.packages = with pkgs; [tailscale tailscale-systray];

  # wayland.windowManager.hyprland.settings.exec-once = ["${pkgs.tailscale-systray}/bin/tailscale-systray"];
}
