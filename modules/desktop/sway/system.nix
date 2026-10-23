{
  flake.modules.nixos.sway = {
    config,
    lib,
    ...
  }: {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = [];
      extraOptions = lib.optional (lib.elem "nvidia" config.services.xserver.videoDrivers) "--unsupported-gpu";
    };

    programs.uwsm = {
      enable = true;
      waylandCompositors.sway = {
        prettyName = "Sway";
        comment = "Sway compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/sway";
      };
    };

    # Screen sharing
    xdg.portal.wlr.enable = true;
  };
}
