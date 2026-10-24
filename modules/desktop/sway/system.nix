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

    # Screen sharing. The portal runs with a minimal PATH: the output picker
    xdg.portal.wlr = {
      enable = true;
      settings.screencast = {
        chooser_type = "dmenu";
        chooser_cmd = "${config.hjem.users.${config.nixy.username}.scripts.tofi-menu}/bin/tofi-menu --prompt-text 'Share: '";
      };
    };
  };
}
