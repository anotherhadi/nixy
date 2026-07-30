# Use yazi as the file picker for portal dialogs (browser "select file(s)" and
# "save download to..."). The backend is xdg-desktop-portal-termfilechooser,
# enabled system-wide in nixos/utils.nix (extraPortals + FileChooser routing).
{
  config,
  pkgs,
  ...
}: let
  wrapper = "${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh";
  # ghostty must run in the foreground instead of handing off to the
  # single-instance daemon, otherwise the wrapper returns before you've picked
  # anything and the portal reads an empty selection.
  termcmd = "ghostty --gtk-single-instance=false --title=termfilechooser -e";
in {
  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${wrapper}
    default_dir=$HOME
    open_mode=suggested
    save_mode=suggested
    env=TERMCMD=${termcmd}
        PATH=${config.home.profileDirectory}/bin:/run/current-system/sw/bin:/run/wrappers/bin
  '';
}
