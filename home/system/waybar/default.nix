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
    ++ (with scripts; [waybar-osd battery-monitor vol-up vol-down vol-mute mic-mute bright-up bright-down nightshift-toggle focus-toggle waybar-toggle wifi-toggle bluetooth-toggle dnd-toggle output-cycle input-cycle color-pick screenshot-edit record-toggle power-cycle airplane-toggle clipboard-menu emoji-picker caffeine-toggle mic-status]);

  # Poll battery level every 30s; battery-monitor no-ops when no battery exists.
  systemd.user.services.battery-monitor = {
    Unit.Description = "Low-battery OSD and critical notification monitor";
    Service = {
      Type = "oneshot";
      ExecStart = "${scripts.battery-monitor}/bin/battery-monitor";
    };
  };

  systemd.user.timers.battery-monitor = {
    Unit.Description = "Poll battery level for low-battery alerts";
    Timer = {
      OnBootSec = "1min";
      OnUnitActiveSec = "30s";
    };
    Install.WantedBy = ["timers.target"];
  };

  wayland.windowManager.hyprland.settings.exec-once = [
    "waybar"
  ];
}
