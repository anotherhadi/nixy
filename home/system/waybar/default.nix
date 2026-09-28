{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./scripts
    ./settings.nix
    ./style.nix
  ];

  programs.waybar.enable = true;
  stylix.targets.waybar.enable = false;

  home.packages = with pkgs;
    [
      playerctl
      pavucontrol
      hyprsunset
    ]
    ++ (with config.scripts; [waybar-osd waybar-osd-status vol-up vol-down vol-mute mic-mute bright-up bright-down waybar-toggle wifi-toggle bluetooth-toggle output-cycle input-cycle color-pick screenshot-edit record-toggle airplane-toggle mic-status]);

  xdg.desktopEntries.waybar-toggle = {
    name = "Toggle Waybar";
    exec = "${config.scripts.waybar-toggle}/bin/waybar-toggle";
    icon = "panel-applets-symbolic";
    comment = "Show or hide the status bar";
    categories = ["System"];
    terminal = false;
  };

  wayland.windowManager.hyprland.settings.exec-once = [
    "waybar"
  ];
}
