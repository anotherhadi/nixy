# Hyprpanel is the bar on top of the screen
# Display informations like workspaces, battery, wifi, ...
{ inputs, pkgs, config, ... }:
let
  transparentButtons = config.var.theme.bar.transparentButtons;

  accent = "#${config.lib.stylix.colors.base0D}";
  accent-alt = "#${config.lib.stylix.colors.base03}";
  background = "#${config.lib.stylix.colors.base00}";
  background-alt = "#${config.lib.stylix.colors.base01}";
  foreground = "#${config.lib.stylix.colors.base05}";
  font = "${config.stylix.fonts.serif.name}";
  fontSize = "${toString config.stylix.fonts.sizes.desktop}";

  rounding = config.var.theme.rounding;
  border-size = config.var.theme.border-size;

  gaps-out = config.var.theme.gaps-out;
  gaps-in = config.var.theme.gaps-in;

  floating = config.var.theme.bar.floating;
  transparent = config.var.theme.bar.transparent;
  position = config.var.theme.bar.position;

  location = config.var.location;
  username = config.var.username;
in {

  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];

  programs.hyprpanel = {
    enable = true;
    systemd.enable = true;
    hyprland.enable = true;
    overwrite.enable = true;
  };
}
