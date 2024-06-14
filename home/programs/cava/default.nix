{ config, ... }: {
  programs.cava = {
    enable = true;
    settings = {
      general.framerate = 60;
      smoothing.noise_reduction = 88;
      color = {
        background = "'#${config.var.theme.colors.bg}'";
        foreground = "'#${config.var.theme.colors.accent}'";
      };
    };
  };
}
