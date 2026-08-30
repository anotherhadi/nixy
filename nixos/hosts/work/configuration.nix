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
    ../../home/programs/gui/helium/system.nix # I hate browser's configuration..

    # CHANGEME: You should probably remove those things:
   # ./persistence.nix # impermanence: what to keep once "/" is wiped on boot
   # ./usbguard.nix
    ./disko.nix
    ./secrets

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  users.users.${config.var.username}.hashedPassword = "$y$j9T$quUlRuvuYJ18asD8SUrh11$0mHCP7ZRIOYjNHY0oT.aFfVho1V0M65eClLzVo0RARD"; # CHANGEME: This is my password

  # Don't touch this
  system.stateVersion = "26.05";
}
