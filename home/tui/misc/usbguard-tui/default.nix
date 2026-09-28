# TUI for managing USBGuard rules
{pkgs, ...}: {
  home.packages = [
    pkgs.nur.repos.anotherhadi.usbguard-tui
  ];

  xdg.desktopEntries.usbguard-tui = {
    name = "USBGuard TUI";
    exec = "${pkgs.ghostty}/bin/ghostty +new-window -e ${pkgs.polkit}/bin/pkexec ${pkgs.nur.repos.anotherhadi.usbguard-tui}/bin/usbguard-tui";
    comment = "Manage USBGuard rules";
    categories = ["Settings"];
    terminal = false;
    settings.Keywords = "usb;usbguard;security;devices;rules";
  };
}
