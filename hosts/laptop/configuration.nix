{ config, ... }: {
  imports = [
    ../modules/fonts.nix
    ../modules/nvidia.nix
    ../modules/prime.nix
    ../modules/xorg.nix
    ../modules/zsh.nix
    ../modules/tuigreet.nix
    ../modules/auto-upgrade.nix
    ../modules/timezone.nix
    ../modules/usb.nix
    ../modules/systemd-boot.nix
    ../modules/users.nix
    ../modules/audio.nix
    ../modules/bluetooth.nix
    ../modules/tailscale.nix
    ../modules/nix.nix
    ../modules/network-manager.nix
    ../modules/home-manager.nix
    ../modules/power-profiles.nix
    ../modules/utils.nix
    ../modules/gvfs.nix
    # ../modules/ovpn.nix

    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
