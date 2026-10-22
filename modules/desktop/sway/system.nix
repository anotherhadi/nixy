# Sway: minimal i3-like Wayland compositor, an alternative session to Hyprland
# (pick "Sway (UWSM)" in tuigreet). User config lives in ./default.nix.
{
  flake.modules.nixos.sway = {
    config,
    lib,
    ...
  }: {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = []; # Everything comes from the desktop aspect
      # Sway refuses to start on the proprietary driver without it
      extraOptions = lib.optional (lib.elem "nvidia" config.services.xserver.videoDrivers) "--unsupported-gpu";
    };

    # Managed by uwsm like Hyprland, so graphical-session.target units (hypridle,
    # hyprpaper, swaync...) start with it
    programs.uwsm = {
      enable = true;
      waylandCompositors.sway = {
        prettyName = "Sway";
        comment = "Sway compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/sway";
      };
    };

    xdg.portal.wlr.enable = true; # Screen sharing
  };
}
