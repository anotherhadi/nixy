{config, ...}: {
  imports = [
    # Mostly system related configuration
    ../../nixos/nvidia.nix # CHANGEME: Remove this line if you don't have an Nvidia GPU
    ../../nixos/audio.nix
    ../../nixos/bluetooth.nix
    ../../nixos/fonts.nix
    ../../nixos/home-manager.nix
    ../../nixos/nix.nix
    ../../nixos/lanzaboot.nix
    ../../nixos/tuigreet.nix
    ../../nixos/autologin.nix # Skip first TUIGreet login, use LUKS password to unlock the keyring
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ../../nixos/hyprland.nix
    ../../nixos/steam.nix
    ../../nixos/kernel-hardening.nix
    ../../home/gui/helium/system.nix # I hate browser's configuration..

    # CHANGEME: You should probably remove those things:
    ./wireguard.nix
    ./secrets

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # User password
  users.users.${config.var.username}.hashedPassword = "$y$j9T$A7gH534UczuBxulj9IfEu1$ImRy3lpYpemRWNVIkA7efKPWXneFiqhZnEF1aMkWcD8"; # CHANGEME: This is my password

  # Impermanence: declares what should survive a wipe of "/".
  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/etc/NetworkManager/system-connections" # Wifi connections, VPN
      "/var/lib/bluetooth" # Bluetooth connections
      "/var/lib/nixos" # keeps uid/gid stable across boots
      "/var/lib/systemd/coredump"
      "/var/lib/upower" # battery calibration state
      "/var/lib/systemd/backlight" # remembers screen brightness
      "/var/lib/systemd/timers" # last-run timestamps (e.g. nix gc weekly)
      "/var/log"
      "/var/db/sudo/lectured" # remembers that the sudo lecture was already shown
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/var/lib/systemd/random-seed" # avoid a weak entropy pool on first boot
    ];
  };

  # USBGuard:
  # The following line allow all USB devices until a proper policy is configured.
  # Run `sudo usbguard generate-policy` with your devices plugged in,
  # then set rules = "<output>" and switch implicitPolicyTarget to "block".
  # services.usbguard.implicitPolicyTarget = lib.mkForce "allow";
  services.usbguard = {
    enable = true;
    implicitPolicyTarget = "block";
    IPCAllowedUsers = [
      "root"
    ];
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
