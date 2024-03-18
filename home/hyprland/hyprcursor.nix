{ config, pkgs, ... }: {
  home.packages = with pkgs; [ hyprcursor ];

  #  home.file.".local/share/icons/rose-pine-hyprcursor" = {
  #    recursive = true;
  #    source = ./rose-pine;
  #  };

}
