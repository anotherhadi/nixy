{pkgs, ...}: {
  home.packages = with pkgs; [
    protonvpn-gui
    proton-pass
    proton-authenticator
  ];

  # Fix Proton Authenticator desktop entry
  xdg.desktopEntries = {
    "Proton Authenticator" = {
      name = "Proton Authenticator";
      exec = "env WEBKIT_DISABLE_COMPOSITING_MODE=1 ${pkgs.proton-authenticator}/bin/proton-authenticator";
      icon = "proton-authenticator";
      type = "Application";
      categories = ["Utility"];
      terminal = false;
    };
  };

  # Auto-statrt Proton VPN

  wayland.windowManager.hyprland.settings.exec-once = [
    "protonvpn-app --start-minimized &"
  ];
}
