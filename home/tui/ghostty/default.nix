# Ghostty is a terminal emulator
{
  pkgs,
  config,
  ...
}: let
  cursorShaders = pkgs.fetchFromGitHub {
    owner = "sahaj-b";
    repo = "ghostty-cursor-shaders";
    rev = "06d4e90fb5410e9c4d0b3131584060adddf89406";
    hash = "sha256-G/UIr1bKnxn1AcHl/4FL/jou6b7M2VeREslYVELxdmw=";
  };
  c = config.lib.stylix.colors;
in {
  home.sessionVariables = {
    TERMINAL = "ghostty";
    TERM = "ghostty";
  };

  programs.ghostty = {
    enable = true;
    installVimSyntax = true;
    enableZshIntegration = true;
    settings = {
      window-padding-x = 10;
      confirm-close-surface = false;
      window-padding-y = 10;
      gtk-single-instance = true;
      clipboard-read = "allow";
      clipboard-write = "allow";
      copy-on-select = "clipboard";
      app-notifications = false;
      custom-shader = "${cursorShaders}/cursor_warp.glsl";
      custom-shader-animation = "always";
      mouse-scroll-multiplier = "discrete:1";
      keybind = [
        "shift+ctrl+tab=new_tab"
      ];
    };
  };
}
