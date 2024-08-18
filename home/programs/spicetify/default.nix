{ pkgs, config, lib, inputs, ... }:
let spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {

  imports = [ inputs.spicetify-nix.homeManagerModules.default ];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "spotify" ];
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.text;
    colorScheme = "custom";

    customColorScheme = {
      text = "${config.var.theme.colors.fg}";
      subtext = "${config.var.theme.colors.fgalt}";
      sidebar-text = "${config.var.theme.colors.fgalt}";
      main = "${config.var.theme.colors.bg}";
      sidebar = "${config.var.theme.colors.bg}";
      background = "${config.var.theme.colors.bg}";
      player = "${config.var.theme.colors.bg}";
      card = "${config.var.theme.colors.bg}";
      shadow = "000000";
      selected-row = "${config.var.theme.colors.bgalt}";
      button = "${config.var.theme.colors.accent}";
      button-active = "${config.var.theme.colors.accent}";
      button-disabled = "${config.var.theme.colors.bgalt}";
      tab-active = "${config.var.theme.colors.accent}";
      misc = "${config.var.theme.colors.fgalt}";
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
