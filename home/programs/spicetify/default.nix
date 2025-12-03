# Spicetify is a spotify client customizer
{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  accent = "${config.lib.stylix.colors.base0D}";
  background = "${config.lib.stylix.colors.base00}";
in {
  imports = [inputs.spicetify-nix.homeManagerModules.default];

  stylix.targets.spicetify.enable = false;

  programs.spicetify = {
    enable = true;
    theme = lib.mkForce spicePkgs.themes.dribbblish;

    colorScheme = "custom";

    customColorScheme = {
      button = accent;
      button-active = accent;
      tab-active = accent;
      player = background;
      main = background;
      sidebar = background;
    };

    enabledExtensions = with spicePkgs.extensions; [
      playlistIcons
      lastfm
      historyShortcut
      hidePodcasts
      adblock
      fullAppDisplay
      keyboardShortcut
    ];
  };
}
