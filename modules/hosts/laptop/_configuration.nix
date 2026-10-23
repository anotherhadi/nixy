{config, ...}: {
  imports = [
    # CHANGEME: You should probably remove those things:
    ./_wireguard.nix
    ./_secrets

    ./_hardware-configuration.nix
  ];

  # User side: features add their files through hjem.extraModules, this is what's host-specific
  hjem.users.${config.nixy.username} = {
    enable = true;

    environment.sessionVariables = {
      # CHANGEME: Related to the GPU, the first one renders (symlinks from the udev rules below)
      WLR_DRM_DEVICES = "/dev/dri/amd-igpu:/dev/dri/nvidia-dgpu";
    };

    # Screens
    xdg.config.files."kanshi/config".text = let
      laptop = ''output "BOE 0x0B7D Unknown" enable mode 2560x1440@240Hz position 0,0 scale 1'';
    in ''
      profile undocked {
        ${laptop}
      }

      profile docked {
        ${laptop}
        output "AOC U34G2G1 0x00000E06" enable mode 3440x1440@99.982Hz position 2560,0 scale 1
      }
    '';
  };

  # Stable names for the GPUs: cardN numbers change between boots
  # CHANGEME: PCI addresses from `ls -l /dev/dri/by-path/`
  services.udev.extraRules = ''
    SUBSYSTEM=="drm", KERNEL=="card*", KERNELS=="0000:05:00.0", SYMLINK+="dri/amd-igpu"
    SUBSYSTEM=="drm", KERNEL=="card*", KERNELS=="0000:01:00.0", SYMLINK+="dri/nvidia-dgpu"
  '';

  # User password
  users.users.${config.nixy.username}.hashedPassword = "$y$j9T$A7gH534UczuBxulj9IfEu1$ImRy3lpYpemRWNVIkA7efKPWXneFiqhZnEF1aMkWcD8"; # CHANGEME: This is my password

  # USB devices allowed on this machine
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
