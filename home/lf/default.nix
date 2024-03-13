{ pkgs, config, ... }: {
  home.packages = with pkgs; [ pistol ];

  programs.lf = {
    enable = true;
    keybindings = {
      d = "delete";
      x = "cut";
      "<enter>" = "open";
      "<c-g>" = "quit";
      "<esc>" = "quit";
      "H" = "set hidden!";
    };

    settings = { ratios = [ 1 1 2 ]; };

    previewer.source = "${pkgs.pistol}/bin/pistol";

    extraConfig = ''
      set nodirfirst 
      set incsearch 
      set icons
      set drawbox
    '';

  };

  xdg.configFile."lf" = {
    recursive = true;
    source = ./config;
  };
}
