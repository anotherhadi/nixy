{ config, ... }: {
  programs.cava = {
    enable = true;
    settings = {
      general.framerate = 60;
      smoothing.noise_reduction = 88;
      color = {
        background = "'#${config.theme.colors.bg}'";
        foreground = "'#${config.theme.colors.primary-bg}'";
      };
    };
  };
}
