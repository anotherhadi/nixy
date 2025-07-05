{ config, inputs, pkgs, ... }: {
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
    ../../nixos/tailscale.nix
    ../../nixos/hyprland.nix

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  environment.systemPackages = [
    inputs.swww.packages.${pkgs.system}.swww
  ];

 
  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
