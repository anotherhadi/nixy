{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      pkgs,
      scripts,
      ...
    }: let
      brightGetText = ''
        BRIGHT=$(${pkgs.brightnessctl}/bin/brightnessctl -m | awk -F, '{print int($4)}')
        if [ "$BRIGHT" -lt 33 ]; then
          OSD_TEXT="󰃞  $BRIGHT%"
        elif [ "$BRIGHT" -lt 66 ]; then
          OSD_TEXT="󰃟  $BRIGHT%"
        else
          OSD_TEXT="󰃠  $BRIGHT%"
        fi
      '';

      updateOsd = ''
        ${scripts.osd}/bin/osd "$OSD_TEXT" brightness
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

      launcher.bright-up.name = "Brightness Up";
      launcher.bright-down.name = "Brightness Down";

      packages = [pkgs.brightnessctl];
    })
  ];
}
