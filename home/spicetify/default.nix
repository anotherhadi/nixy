{ pkgs, config, lib, spicetify-nix, ... }:
let spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in {

  imports = [ spicetify-nix.homeManagerModules.default ];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "spotify" ];
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.text;
    colorScheme = "custom";

    customColorScheme = {
      text = "${config.theme.colors.fg}";
      subtext = "${config.theme.colors.alt-fg}";
      sidebar-text = "${config.theme.colors.alt-fg}";
      main = "${config.theme.colors.bg}";
      sidebar = "${config.theme.colors.bg}";
      background = "${config.theme.colors.bg}";
      player = "${config.theme.colors.bg}";
      card = "${config.theme.colors.bg}";
      shadow = "000000";
      selected-row = "797979";
      button = "31748f";
      button-active = "31748f";
      button-disabled = "555169";
      tab-active = "00FF00";
      misc = "00FF00";
    };

    enabledExtensions = with spicePkgs.extensions; [
      playlistIcons
      lastfm
      historyShortcut
      hidePodcasts
      fullAppDisplay
      shuffle
    ];
  };
}
