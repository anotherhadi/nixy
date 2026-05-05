{config, ...}: {
  imports = [
    # Mostly system related configuration
    ../../nixos/nvidia.nix # CHANGEME: Remove this line if you don't have an Nvidia GPU
    ../../nixos/audio.nix
    ../../nixos/bluetooth.nix
    ../../nixos/fonts.nix
    ../../nixos/home-manager.nix
    ../../nixos/nix.nix
    ../../nixos/systemd-boot.nix
    ../../nixos/sddm.nix
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ../../nixos/hyprland.nix
    ../../nixos/usbguard.nix

    ../../nixos/omen.nix # CHANGEME: For my laptop only, remove this (OMEN 16)

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  # USBGuard:
  # Allow all USB devices until a proper policy is configured.
  # Run `sudo usbguard generate-policy` with your devices plugged in,
  # then set rules = "<output>" and switch implicitPolicyTarget to "block".
  # services.usbguard.implicitPolicyTarget = lib.mkForce "allow";

  services.usbguard.rules = ''
    allow id 1d6b:0002 serial "0000:05:00.3" name "xHCI Host Controller" hash "4a4NgfdUaJO43rkCzmWRSeHHR/uUh5+SNsXnhosm9qs=" parent-hash "ldMchY4Tt4GPUYo30eNGvai+Fs/EdnVY3vMyxJUq4Nk=" with-interface 09:00:00 with-connect-type ""
    allow id 1d6b:0003 serial "0000:05:00.3" name "xHCI Host Controller" hash "d+DNGWARDtv9nEK2ZvnNOCtFernuMu5/e/oZ7kCppqQ=" parent-hash "ldMchY4Tt4GPUYo30eNGvai+Fs/EdnVY3vMyxJUq4Nk=" with-interface 09:00:00 with-connect-type ""
    allow id 1d6b:0002 serial "0000:05:00.4" name "xHCI Host Controller" hash "icotY3rI59mWiKsGxc59BGZZeBjfbuH0b4NUByj3cbQ=" parent-hash "tHvBfznK5rpQn+oa0PEEjHa29EAEvGyCcZixsfwA6W0=" with-interface 09:00:00 with-connect-type ""
    allow id 1d6b:0003 serial "0000:05:00.4" name "xHCI Host Controller" hash "UbEoCZW8HT2ldc3qDeiK+IiQlGeaBC7F63681OwmKhI=" parent-hash "tHvBfznK5rpQn+oa0PEEjHa29EAEvGyCcZixsfwA6W0=" with-interface 09:00:00 with-connect-type ""
    allow id 1d6b:0002 serial "0000:07:00.3" name "xHCI Host Controller" hash "pz29Oo0RhQ+5+7LgOZR4v3OlcsVv3m9kCgGsGUnoUjI=" parent-hash "DRyV2/31MYHdzkIEfbPQeb/1w4/PjOW6GqWrXkftf2I=" with-interface 09:00:00 with-connect-type ""
    allow id 1d6b:0003 serial "0000:07:00.3" name "xHCI Host Controller" hash "O6iOpcl9StImWT62SrbeXacqbG6N/mTIipTRc0ipCGM=" parent-hash "DRyV2/31MYHdzkIEfbPQeb/1w4/PjOW6GqWrXkftf2I=" with-interface 09:00:00 with-connect-type ""
    allow id 1d6b:0002 serial "0000:07:00.4" name "xHCI Host Controller" hash "Hp8B0Enf+ACRT2tyy0EqXj7eNsFDAnTRZadzuh/Iqd4=" parent-hash "l2vhvC+VGVKlkBUUK/usFu8jHJ/5bWOnJG6WzRexpt4=" with-interface 09:00:00 with-connect-type ""
    allow id 1d6b:0003 serial "0000:07:00.4" name "xHCI Host Controller" hash "rJ3LKdvkCK3SUrCU3lV8qVbmPjA+r9Fe5106x2HlgK4=" parent-hash "l2vhvC+VGVKlkBUUK/usFu8jHJ/5bWOnJG6WzRexpt4=" with-interface 09:00:00 with-connect-type ""
    allow id 0bda:c85c serial "00e04c000001" name "Bluetooth Radio" hash "Q/wlToV8WQgEYHBW/UIhnSwCCusCGqAR2D5gspSCImQ=" parent-hash "4a4NgfdUaJO43rkCzmWRSeHHR/uUh5+SNsXnhosm9qs=" with-interface { e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 } with-connect-type "hardwired"
    allow id 30c9:009f serial "01.00.00" name "HP True Vision FHD Camera" hash "eYW5fqReJd29tfHXkEktKC63dGfDpmlRMo5uMGUWwME=" parent-hash "icotY3rI59mWiKsGxc59BGZZeBjfbuH0b4NUByj3cbQ=" with-interface { 0e:01:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 0e:02:01 fe:01:01 } with-connect-type "hardwired"
    allow id 03f0:036b serial "" name "HP USB-C Dock G5" hash "iPFGrgGz0sWgKQjWD/F8eNOhkeR728dTG8JJtkUSvuM=" parent-hash "Hp8B0Enf+ACRT2tyy0EqXj7eNsFDAnTRZadzuh/Iqd4=" via-port "7-1" with-interface { 09:00:01 09:00:02 } with-connect-type "hotplug"
    allow id 03f0:066b serial "" name "HP USB-C Dock G5" hash "JHDjLFApQNqijjmuKdJSWH5+1oLL7S6LQ9QHTAk5fTk=" parent-hash "rJ3LKdvkCK3SUrCU3lV8qVbmPjA+r9Fe5106x2HlgK4=" via-port "8-1" with-interface 09:00:00 with-connect-type "hotplug"
    allow id 03f0:056b serial "201604140001" name "USB Audio" hash "OxQ8HQenW3/4HSGEBOSYFS15rXDTOaNDnjMbICweHgw=" parent-hash "iPFGrgGz0sWgKQjWD/F8eNOhkeR728dTG8JJtkUSvuM=" with-interface { 01:01:00 01:02:00 01:02:00 01:02:00 01:02:00 03:00:00 } with-connect-type "unknown"
    allow id 03f0:086b serial "" name "USB2734" hash "MSXcPAlZqkpTyZQylOhSIB8eMfST2AzVHV9EbrBGTWc=" parent-hash "iPFGrgGz0sWgKQjWD/F8eNOhkeR728dTG8JJtkUSvuM=" via-port "7-1.3" with-interface { 09:00:01 09:00:02 } with-connect-type "unknown"
    allow id 03f0:046b serial "11AD1D0A89EA2D08310E0B00" name "HP USB-C Dock G5" hash "DEGeuj1u4lwqrzp0UksFX7mSEY9JnGLxg7yxGbglAKE=" parent-hash "iPFGrgGz0sWgKQjWD/F8eNOhkeR728dTG8JJtkUSvuM=" with-interface { 11:00:00 ff:03:00 03:00:00 } with-connect-type "unknown"
    allow id 03f0:076b serial "" name "USB5734" hash "BshoqybYo0IKgoDORYPRtbhhlmQrYAxPQb2EAm1JsWA=" parent-hash "JHDjLFApQNqijjmuKdJSWH5+1oLL7S6LQ9QHTAk5fTk=" via-port "8-1.3" with-interface 09:00:00 with-connect-type "unknown"
    allow id 0bda:8153 serial "000001000000" name "USB 10/100/1000 LAN" hash "utEnXKJ57kRUbPcGUaNWhEyoOEbLOYAFxvlsyC0PZkk=" parent-hash "JHDjLFApQNqijjmuKdJSWH5+1oLL7S6LQ9QHTAk5fTk=" with-interface { ff:ff:00 02:06:00 0a:00:00 0a:00:00 } with-connect-type "unknown"
    allow id 046d:0ab7 serial "2046BAB04T68" name "Blue Microphones" hash "cC6AQ2e1Q/BeFeostpbf1mH2WpoUmt6bhau4NlA3niU=" parent-hash "MSXcPAlZqkpTyZQylOhSIB8eMfST2AzVHV9EbrBGTWc=" with-interface { 01:01:00 01:02:00 01:02:00 01:02:00 01:02:00 01:02:00 01:02:00 03:00:00 } with-connect-type "unknown"
    allow id 1532:02a1 serial "" name "Razer Ornata V3" hash "wfuIjBhhGuge8gflyA526SKqKoy8rHJZQZ+2o6usMiE=" parent-hash "MSXcPAlZqkpTyZQylOhSIB8eMfST2AzVHV9EbrBGTWc=" via-port "7-1.3.3" with-interface { 03:01:01 03:00:01 03:00:02 } with-connect-type "unknown"
    allow id 13fd:5900 serial "50026B76861EE752    " name "External" hash "l/QvVV5hzZj1z6OUwB/kWl+WnH/7awrdMBoiNVx660M=" parent-hash "MSXcPAlZqkpTyZQylOhSIB8eMfST2AzVHV9EbrBGTWc=" with-interface { 08:06:50 08:06:62 } with-connect-type "unknown"
  '';

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
