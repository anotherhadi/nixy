{config, ...}: {
  imports = [
    # CHANGEME: You should probably remove those things:
    ./_secrets
    ./_wireguard.nix

    # You should let those lines as is
    ./_hardware-configuration.nix
  ];

  hjem.users.${config.nixy.username} = {
    lib,
    pkgs,
    ...
  }: {
    enable = true;

    sway.config = ''
      output "Philips Consumer Electronics Company PHL 252B9 UHB2223003334" position 0 0 scale 1
    '';

    # Work identity everywhere, personal identity on GitHub remotes
    xdg.config.files."git/config".value.includeIf = let
      identity = name: email: pkgs.writeText "gitconfig-${name}" (lib.generators.toGitINI {user = {inherit name email;};});
    in {
      "hasconfig:remote.*.url:**".path = identity "Hadrien" "hadi@example.fr";
      "hasconfig:remote.*.url:git@github.com:*/**".path = identity config.nixy.git.name config.nixy.git.email;
    };
  };

  users.users.${config.nixy.username}.hashedPassword = "$y$j9T$quUlRuvuYJ18asD8SUrh11$0mHCP7ZRIOYjNHY0oT.aFfVho1V0M65eClLzVo0RARD"; # CHANGEME: This is my password

  # USB devices allowed on this machine (modules/system/usbguard.nix)
  services.usbguard = {
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
