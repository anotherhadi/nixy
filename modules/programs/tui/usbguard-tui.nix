# TUI for managing USBGuard rules
{aspects, ...}: {
  flake.modules.nixos.usbguard-tui = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({
        pkgs,
        scripts,
        ...
      }: let
        usbguard-tui = pkgs.nur.repos.anotherhadi.usbguard-tui;
      in {
        packages = [
          usbguard-tui
          (pkgs.makeDesktopItem {
            name = "usbguard-tui";
            desktopName = "USBGuard TUI";
            exec = "${scripts.term}/bin/term ${pkgs.polkit}/bin/pkexec ${usbguard-tui}/bin/usbguard-tui";
            comment = "Manage USBGuard rules";
            categories = ["Settings"];
            terminal = false;
            keywords = ["usb" "usbguard" "security" "devices" "rules"];
          })
        ];
      })
    ];
  };
}
