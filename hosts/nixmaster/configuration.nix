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
    ../../nixos/tuigreet.nix
    ../../nixos/autologin.nix # Skip first TUIGreet login, use LUKS password to unlock the keyring
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ../../nixos/hyprland.nix
    ../../nixos/steam.nix
    ../../home/programs/gui/helium/system.nix # I hate browser's configuration..

    # CHANGEME: You should probably remove those things:
    #./wireguard.nix
    #./persistence.nix # impermanence: what to keep once "/" is wiped on boot
    #./usbguard.nix
    #./disko.nix
    #./secrets

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  users.users.${config.var.username}.hashedPassword = "$y$j9T$.lpL0xVWdVGlw3CczCoSf0$Vc9U2NhwMiB5uLHm0aecSMTJHo19ng8HN/UFGPKENMC"; # CHANGEME: This is my password. Run mkpasswd -m yescrypt to generate new one.

  # Don't touch this
  system.stateVersion = "26.05";
}
