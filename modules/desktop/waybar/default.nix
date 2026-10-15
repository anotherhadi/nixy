# Waybar: status bar (settings.nix, style.nix, scripts/)
{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      pkgs,
      scripts,
      ...
    }: {
      packages = with pkgs;
        [
          waybar
          playerctl
          pavucontrol
          hyprsunset
          (makeDesktopItem {
            name = "waybar-toggle";
            desktopName = "Toggle Waybar";
            exec = "${scripts.waybar-toggle}/bin/waybar-toggle";
            icon = "panel-applets-symbolic";
            comment = "Show or hide the status bar";
            categories = ["System"];
            terminal = false;
          })
        ]
        ++ (with scripts; [waybar-osd waybar-osd-status vol-up vol-down vol-mute mic-mute bright-up bright-down waybar-toggle wifi-toggle bluetooth-toggle output-cycle input-cycle color-pick screenshot-edit record-toggle airplane-toggle mic-status]);

      hyprland.settings.exec-once = [
        "waybar"
      ];
    })
  ];
}
