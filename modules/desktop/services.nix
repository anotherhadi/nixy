# System services a graphical session relies on: input, keyring, portals,
# virtual filesystems (trash, mtp...), GSettings
{
  flake.modules.nixos.desktop = {pkgs, ...}: {
    services = {
      gnome.gnome-keyring.enable = true;
      gvfs.enable = true;
      dbus.packages = [pkgs.gcr];
      # On by default with a graphical session, pulls ~700 MiB of voices
      speechd.enable = false;
    };

    programs.dconf.enable = true;

    xdg.portal = {
      xdgOpenUsePortal = false;
      config.common.default = ["gtk"];
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };
  };
}
