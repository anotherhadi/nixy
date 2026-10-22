{config, ...}: {
  imports = [
    # CHANGEME: You should probably remove those things:
    ./_wireguard.nix
    ./_secrets

    # You should let those lines as is
    ./_hardware-configuration.nix
  ];

  # User side: features add their files through hjem.extraModules, this is what's host-specific
  hjem.users.${config.nixy.username} = {
    enable = true;

    environment.sessionVariables = {
      AQ_DRM_DEVICES = "/dev/dri/card2:/dev/dri/card1"; # CHANGEME: Related to the GPU
    };

    hyprland.settings.monitor = [
      "eDP-2,highres,0x0,1" # My internal laptop screen
      "desc:AOC U34G2G1 0x00000E06,3440x1440@99.98,auto,1" # My external monitor
    ];
    sway.config = ''
      output "AOC U34G2G1 0x00000E06" mode 3440x1440@99.980Hz
    '';

    # TODO: Signal-notif

    persist.directories = ["Music"];
  };

  # User password
  users.users.${config.nixy.username}.hashedPassword = "$y$j9T$A7gH534UczuBxulj9IfEu1$ImRy3lpYpemRWNVIkA7efKPWXneFiqhZnEF1aMkWcD8"; # CHANGEME: This is my password

  # USB devices allowed on this machine (modules/system/usbguard.nix)
  services.usbguard = {
    rules = ''
      allow id 13fd:5900 name "External"
      allow id 1d6b:0003 name "xHCI Host Controller"
      allow id 1d6b:0002 name "xHCI Host Controller"
      allow id 0bda:c85c name "Bluetooth Radio"
      allow id 30c9:009f name "HP True Vision FHD Camera"
      allow id 03f0:036b name "HP USB-C Dock G5"
      allow id 03f0:066b name "HP USB-C Dock G5"
      allow id 03f0:056b name "USB Audio"
      allow id 0bda:8153 name "USB 10/100/1000 LAN"
      allow id 046d:0ab7 name "Blue Microphones"
      allow id 03f0:076b name "USB5734"
      allow id 1532:02a1 name "Razer Ornata V3"
      allow id 03f0:046b name "HP USB-C Dock G5"
      allow id 03f0:086b name "USB2734"
      allow id 1b1c:1b75 name "CORSAIR HARPOON RGB PRO Gaming Mouse"
    '';
  };

  # Don't touch this
  system.stateVersion = "26.05";
}
