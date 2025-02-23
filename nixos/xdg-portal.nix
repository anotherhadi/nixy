{ pkgs, ... }: {
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
      pkgs.libsForQt5.xdg-desktop-portal-kde
    ];
    config.hyprland = { default = [ "hyprland" "gtk" ]; };
  };
}
