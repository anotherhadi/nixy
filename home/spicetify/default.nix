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
      selected-row = "${config.theme.colors.alt-bg}";
      button = "${config.theme.colors.primary-bg}";
      button-active = "${config.theme.colors.primary-bg}";
      button-disabled = "${config.theme.colors.alt-bg}";
      tab-active = "${config.theme.colors.primary-bg}";
      misc = "${config.theme.colors.alt-fg}";
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
