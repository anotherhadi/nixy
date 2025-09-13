# Tailscale is a VPN service that works on top of WireGuard.
# It allows me to access my servers and devices from anywhere.
{inputs, ...}: {
  home.packages = with inputs.nixpkgs-stable.legacyPackages.x86_64-linux; [tailscale tailscale-systray];

  # wayland.windowManager.hyprland.settings.exec-once = ["${pkgs.tailscale-systray}/bin/tailscale-systray"];
}
