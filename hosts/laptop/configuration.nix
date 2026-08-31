{config, ...}: {
  imports = [
    # Mostly system related configuration
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
    ../../nixos/kernel-hardening.nix
    ../../home/programs/gui/helium/system.nix # I hate browser's configuration..

    # CHANGEME: You should probably remove those things:
    #./wireguard.nix
    ./persistence.nix # impermanence: what to keep once "/" is wiped on boot
    #./usbguard.nix
    #./disko.nix
    ./secrets

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  # Enable the fingerprint daemon
  services.fprintd.enable = true;

  # Integrate fingerprint authentication into PAM services
  security.pam.services = {
    login.fprintAuth = true;
    su.fprintAuth = true;
    sudo.fprintAuth = true;
    polkit-1.fprintAuth = true;
  };

  home-manager.users."${config.var.username}" = import ./home.nix;

  users.users.${config.var.username}.hashedPassword = "$y$j9T$A7gH534UczuBxulj9IfEu1$ImRy3lpYpemRWNVIkA7efKPWXneFiqhZnEF1aMkWcD8";

  # Don't touch this
  system.stateVersion = "26.05";
}
