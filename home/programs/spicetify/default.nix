{ pkgs, config, lib, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  accent = "${config.lib.stylix.colors.base0D}";
  background = "${config.lib.stylix.colors.base00}";
in {
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  stylix.targets.spicetify.enable = false;

  programs.spicetify = {
    enable = true;
    theme =  {
      name = "text";
      src = spicePkgs.themes.text.src;
      additionalCss = ''
        .main-trackList-rowImage {
          display: var(--display-tracklist-image);
          padding-top: 10px !important;
          padding-bottom: 10px !important;
        }
      '';
    };

    colorScheme = "custom";

    customColorScheme = {
      accent = accent;
      accent-active = accent;
      border-active = accent;
      tab-active = accent;
      player = background;
      sidebar = background;
      highlight = accent;
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
