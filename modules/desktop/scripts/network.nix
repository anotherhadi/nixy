{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      pkgs,
      scripts,
      ...
    }: {
      scripts.wifi-toggle = pkgs.writeShellScriptBin "wifi-toggle" ''
        if ${pkgs.networkmanager}/bin/nmcli radio wifi | grep -q enabled; then
          ${pkgs.networkmanager}/bin/nmcli radio wifi off
        else
          ${pkgs.networkmanager}/bin/nmcli radio wifi on
        fi
      '';

      scripts.airplane-toggle = pkgs.writeShellScriptBin "airplane-toggle" ''
        on=false
        nmcli radio wifi 2>/dev/null | grep -q enabled && on=true
        bluetoothctl show 2>/dev/null | grep -q "Powered: yes" && on=true
        if $on; then
          nmcli radio wifi off 2>/dev/null
          bluetoothctl power off >/dev/null 2>&1 || true
          OSD_TEXT="󰀝  Airplane On"
        else
          nmcli radio wifi on 2>/dev/null
          bluetoothctl power on >/dev/null 2>&1 || true
          OSD_TEXT="󰀞  Airplane Off"
        fi
        ${scripts.osd}/bin/osd "$OSD_TEXT" network
      '';

      launcher.wifi-toggle.name = "Toggle Wi-Fi";
      launcher.airplane-toggle.name = "Airplane Mode";
    })
  ];
}
