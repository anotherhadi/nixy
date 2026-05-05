{
  home.sessionVariables = {
    TERMINAL = "ghostty";
    TERM = "ghostty";
    XMODIFIERS = "@im=none";
    GTK_IM_MODULE = "simple";
  };

  programs.ghostty = {
    enable = true;
    installVimSyntax = true;
    enableZshIntegration = true;
    settings = {
      window-padding-x = 10;
      confirm-close-surface = false;
      window-padding-y = 10;
      clipboard-read = "allow";
      clipboard-write = "allow";
      copy-on-select = "clipboard";
      app-notifications = false;
      keybind = [
        "ctrl+j=goto_split:left"
        "ctrl+i=goto_split:up"
        "ctrl+k=goto_split:down"
        "ctrl+l=goto_split:right"
        "shift+ctrl+h=new_split:left"
        "shift+ctrl+j=new_split:down"
        "shift+ctrl+k=new_split:up"
        "shift+ctrl+l=new_split:right"
        "shift+ctrl+tab=new_tab"
      ];
    };
  };
}
