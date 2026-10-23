{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({pkgs, ...}: {
      scripts.bluetooth-toggle = pkgs.writeShellScriptBin "bluetooth-toggle" ''
        if ${pkgs.bluez}/bin/bluetoothctl show | grep -q "Powered: yes"; then
          ${pkgs.bluez}/bin/bluetoothctl power off
        else
          ${pkgs.bluez}/bin/bluetoothctl power on
        fi
      '';

      launcher.bluetooth-toggle.name = "Toggle Bluetooth";
    })
  ];
}
