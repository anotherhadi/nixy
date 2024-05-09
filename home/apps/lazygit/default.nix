{ config, ... }: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui.theme = {
        ligthTheme = false;
        activeBorderColor = [ "${config.theme.colors.primary-ansi-16}" "bold" ];
        inactiveBorderColor = [ "black" ];
        selectedLineBgColor = [ "default" ];
      };
    };
  };
}
