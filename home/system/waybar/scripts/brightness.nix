{
  pkgs,
  scripts,
  ...
}: let
  brightGetText = ''
    BRIGHT=$(${pkgs.brightnessctl}/bin/brightnessctl -m | awk -F, '{print int($5)}')
    if [ "$BRIGHT" -lt 33 ]; then
      OSD_TEXT="󰃞  $BRIGHT%"
    elif [ "$BRIGHT" -lt 66 ]; then
      OSD_TEXT="󰃟  $BRIGHT%"
    else
      OSD_TEXT="󰃠  $BRIGHT%"
    fi
  '';

  updateOsd = ''
    ${scripts.waybar-osd}/bin/waybar-osd "$OSD_TEXT"
  '';
in {
  scripts.bright-up = pkgs.writeShellScriptBin "bright-up" ''
    ${pkgs.brightnessctl}/bin/brightnessctl set 5%+
    ${brightGetText}
    ${updateOsd}
  '';

  scripts.bright-down = pkgs.writeShellScriptBin "bright-down" ''
    ${pkgs.brightnessctl}/bin/brightnessctl set 5%-
    ${brightGetText}
    ${updateOsd}
  '';
}
