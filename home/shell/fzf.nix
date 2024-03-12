{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    colors = {
      "fg+" = "magenta";
      "bg+" = "-1";
      "fg" = "white";
      "bg" = "-1";
      "prompt" = "grey";
      "pointer" = "magenta";
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
