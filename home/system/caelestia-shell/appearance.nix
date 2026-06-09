{
  pkgs,
  config,
  ...
}: let
  inherit (config.theme) bar-rounding bar-thickness;
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
        enabled = true;
        base = config.theme.active-opacity;
        layers = config.theme.inactive-opacity;
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
      rounding = bar-rounding;
      thickness = bar-thickness;
    };
  };
}
