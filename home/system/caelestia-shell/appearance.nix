{
  pkgs,
  config,
  ...
}: let
  rounding = config.theme.rounding + config.theme.gaps-out;
  inherit (config.stylix) fonts;
in {
  home.packages = with pkgs; [
    papirus-icon-theme
  ];

  programs.caelestia.settings = {
    paths.sessionGif = ./session-gif-hacker-cat.gif;
    background.enabled = false;
    appearance = {
      transparency = {
        enable = true;
        base = 0.85;
        layers = 0.4;
      };
      font.family = {
        material = "Material Symbols Rounded";
        mono = fonts.monospace.name;
        sans = fonts.sansSerif.name;
      };
    };
    utilities = {
      enabled = true;
      maxToasts = 4;
      toasts = {
        audioInputChanged = false;
        audioOutputChanged = false;
        capsLockChanged = false;
        chargingChanged = true;
        configLoaded = false;
        dndChanged = true;
        gameModeChanged = true;
        numLockChanged = false;
        nowPlaying = false;
        kbLayoutChanged = false;
      };
    };
    dashboard.showOnHover = false;
    border = {
      inherit rounding;
      thickness = 8;
    };
  };
}
