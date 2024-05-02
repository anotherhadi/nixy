{ config, ... }: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    colors = {
      "fg+" = config.theme.colors.primary-ansi-16;
      "bg+" = "-1";
      "fg" = "white";
      "bg" = "-1";
      "prompt" = "grey";
      "pointer" = config.theme.colors.primary-ansi-16;
    };
    defaultOptions = [
      "--margin=1"
      "--layout=reverse"
      "--border=rounded"
      "--info='hidden'"
      "--header=''"
      "--prompt='/ '"
      "-i"
      "--no-bold"
    ];
  };
}
