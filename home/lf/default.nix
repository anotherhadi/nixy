{ pkgs, config, ... }: {
  home.packages = with pkgs; [ pistol ];

  programs.lf = {
    enable = true;
    keybindings = {
      # I find x to be a better cut, and save d for delete
      d = "delete";
      x = "cut";
      "<enter>" = "open";
      "<c-g>" = "quit";
      "<esc>" = "quit";
    };

    previewer.source = "${pkgs.pistol}/bin/pistol";

    extraConfig = ''
      set hidden
      set nodirfirst
      set incsearch
    '';

  };
}
