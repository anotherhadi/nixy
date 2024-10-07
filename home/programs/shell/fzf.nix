{ config, lib, ... }: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    colors = lib.mkForce {
      "fg+" = "#" + config.lib.stylix.colors.base0D;
      "bg+" = "-1";
      "fg" = "#" + config.lib.stylix.colors.base05;
      "bg" = "-1";
      "prompt" = "#" + config.lib.stylix.colors.base03;
      "pointer" = "#" + config.lib.stylix.colors.base0D;
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
