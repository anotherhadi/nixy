{ pkgs, config, lib, inputs, ... }:
let spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {

  imports = [ inputs.spicetify-nix.homeManagerModules.default ];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "spotify" ];
  programs.spicetify = {
    enable = true;
    theme = lib.mkForce spicePkgs.themes.text;

    # TODO: Colors not working
    customColorScheme = lib.mkForce {
      button = "#${config.lib.stylix.colors.base0D}";
      button-active = "#${config.lib.stylix.colors.base0D}";
      tab-active = "#${config.lib.stylix.colors.base0D}";
    };

    enabledExtensions = with spicePkgs.extensions; [
      playlistIcons
      lastfm
      historyShortcut
      hidePodcasts
      adblock
      fullAppDisplay
      shuffle
    ];
  };
}
