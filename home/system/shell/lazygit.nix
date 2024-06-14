{ config, ... }: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui.theme = {
        ligthTheme = false;
        activeBorderColor = [ "${config.var.theme.colors.accentName}" "bold" ];
        inactiveBorderColor = [ "black" ];
        selectedLineBgColor = [ "default" ];
      };
    };
  };
}
