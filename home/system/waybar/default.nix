{
  pkgs,
  config,
  ...
}: let
  scripts = import ./scripts.nix {inherit pkgs config;};
in {
  imports = [
    ./settings.nix
    ./style.nix
  ];

  _module.args.scripts = scripts;
  _module.args.osdPath = scripts.osdPath;
  _module.args.networkScript = scripts.networkScript;
  _module.args.bluetoothScript = scripts.bluetoothScript;
  _module.args.volMuteScript = scripts.vol-mute;
  _module.args.caffeineToggleScript = scripts.caffeine-toggle;
  _module.args.osdStatusScript = scripts.waybar-osd-status;
  _module.args.nightshiftToggleScript = scripts.nightshift-toggle;

  programs.waybar.enable = true;
  stylix.targets.waybar.enable = false;

  home.packages = with pkgs;
    [
      playerctl
      pavucontrol
      hyprsunset
    ]
    ++ (with scripts; [waybar-osd waybar-osd-status vol-up vol-down vol-mute mic-mute bright-up bright-down nightshift-toggle focus-toggle waybar-toggle wifi-toggle bluetooth-toggle dnd-toggle output-cycle input-cycle color-pick screenshot-edit record-toggle power-cycle airplane-toggle clipboard-menu emoji-picker caffeine-toggle mic-status]);

  wayland.windowManager.hyprland.settings.exec-once = [
    "waybar"
  ];
}
