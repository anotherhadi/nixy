{pkgs, ...}: let
  scripts = import ./scripts.nix {inherit pkgs;};
in {
  imports = [
    ./settings.nix
    ./style.nix
  ];

  _module.args.networkScript = scripts.networkScript;
  _module.args.bluetoothScript = scripts.bluetoothScript;

  programs.waybar.enable = true;
  stylix.targets.waybar.enable = false;

  home.packages = with pkgs;
    [
      playerctl
      pavucontrol
      blueman
      iw
      hyprsunset
    ]
    ++ (with scripts; [vol-up vol-down vol-mute mic-mute bright-up bright-down nightshift-toggle focus-toggle waybar-toggle wifi-toggle bluetooth-toggle]);

  wayland.windowManager.hyprland.settings.exec-once = [
    "waybar"
  ];
}
