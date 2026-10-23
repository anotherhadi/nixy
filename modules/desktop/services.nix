# System services a graphical session relies on: input, keyring, portals,
# virtual filesystems (trash, mtp...), GSettings
{
  flake.modules.nixos.desktop = {pkgs, ...}: {
    services = {
      gnome.gnome-keyring.enable = true;
      gvfs.enable = true;
      dbus.packages = [pkgs.gcr];
    };

    programs.dconf.enable = true;

    xdg.portal = {
      xdgOpenUsePortal = false;
      config.common.default = ["gtk"];
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };
  };
}
