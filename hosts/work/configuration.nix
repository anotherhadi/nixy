{config, ...}: {
  imports = [
    # Mostly system related configuration
    ../../nixos/audio.nix
    ../../nixos/fonts.nix
    ../../nixos/home-manager.nix
    ../../nixos/nix.nix
    ../../nixos/systemd-boot.nix
    ../../nixos/tuigreet.nix
    ../../nixos/autologin.nix # Skip first TUIGreet login, use LUKS password to unlock the keyring
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ../../nixos/hyprland.nix
    ../../nixos/kernel-hardening.nix
    ../../nixos/vulnix.nix
    ../../home/gui/helium/system.nix # I hate browser's configuration..

    # CHANGEME: You should probably remove those things:
    ./secrets
    ./wireguard.nix

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  users.users.${config.var.username}.hashedPassword = "$y$j9T$quUlRuvuYJ18asD8SUrh11$0mHCP7ZRIOYjNHY0oT.aFfVho1V0M65eClLzVo0RARD"; # CHANGEME: This is my password

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
      allow id 1d6b:0002 name "xHCI Host Controller"
      allow id 0951:1666 name "DataTraveler 3.0"
      allow id 1d6b:0003 name "xHCI Host Controller"
      allow id 0461:574a name "HP 125 USB Optical Mouse"
      allow id 0461:554a name "HP 125 Wired Keyboard"
      allow id 1f75:0903 name "USB DISK"
      allow id 17ef:30b7 name "USB2.0 Hub             "
      allow id 1d6b:0003 name "xHCI Host Controller"
      allow id 17ef:30bb name "ThinkPad Thunderbolt 4 Dock USB Audio"
      allow id 1d6b:0002 name "xHCI Host Controller"
      allow id 17ef:30b4 name "ThinkPad Thunderbolt 4 Dock MCU Contoller"
      allow id 17ef:30ba name "V1003"
      allow id 8087:0b40 name "USB3.0 Hub"
      allow id 17ef:30b5 name "40B1"
      allow id 17ef:30b6 name "USB3.1 Hub             "
      allow id 0461:574a name "HP 125 USB Optical Mouse"
      allow id 0461:554a name "HP 125 Wired Keyboard"
      allow id 17ef:30b9 name "USB2.0 Hub             "
      allow id 0bda:8153 name "USB 10/100/1000 LAN"
      allow id 17ef:30b8 name "USB3.1 Hub             "
    '';
  };

  # Don't touch this
  system.stateVersion = "26.05";
}
