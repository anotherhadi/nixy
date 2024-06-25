{ config, ... }: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    colors = {
      "fg+" = config.var.theme.colors.accentName;
      "bg+" = "-1";
      "fg" = "white";
      "bg" = "-1";
      "prompt" = "grey";
      "pointer" = config.var.theme.colors.accentName;
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
