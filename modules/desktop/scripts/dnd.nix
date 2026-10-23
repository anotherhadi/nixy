# Do Not Disturb
{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      pkgs,
      scripts,
      ...
    }: {
      scripts.dnd-toggle = pkgs.writeShellScriptBin "dnd-toggle" ''
        state=$(${pkgs.swaynotificationcenter}/bin/swaync-client -d)
        if [ "$state" = "true" ]; then
          OSD_TEXT="󰂛  Do Not Disturb On"
        else
          OSD_TEXT="󰂚  Do Not Disturb Off"
        fi
        ${scripts.osd}/bin/osd "$OSD_TEXT" notifications
      '';

      launcher.dnd-toggle.name = "Do Not Disturb";
    })
  ];
}
