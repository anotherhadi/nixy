# System services a graphical session relies on: input, keyring, portals,
# virtual filesystems (trash, mtp...), GSettings
{
  flake.modules.nixos.desktop = {pkgs, ...}: {
    services = {
      libinput.enable = true;
      xserver.enable = true;
      gnome.gnome-keyring.enable = true;
      gvfs.enable = true;
      dbus.packages = with pkgs; [
        gcr
        gnome-settings-daemon
      ];
    };

    programs.dconf.enable = true;

    xdg.portal = {
      xdgOpenUsePortal = false;
      config = {
        common.default = ["gtk"];
        hyprland.default = [
          "gtk"
          "hyprland"
        ];
      };
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };
  };
}
