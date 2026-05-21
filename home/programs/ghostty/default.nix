{ pkgs, ... }:
let
  cursorShaders = pkgs.fetchFromGitHub {
    owner = "sahaj-b";
    repo = "ghostty-cursor-shaders";
    rev = "06d4e90fb5410e9c4d0b3131584060adddf89406";
    hash = "sha256-G/UIr1bKnxn1AcHl/4FL/jou6b7M2VeREslYVELxdmw=";
  };
in
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
      custom-shader = "${cursorShaders}/cursor_warp.glsl";
      custom-shader-animation = "always";
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
