{ config, pkgs, ... }: {
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
    # ../modules/systemd-boot.nix
    ../modules/grub.nix
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

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrains Mono Nerd Font";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
    };
    targets.nixvim.transparentBackground = {
      main = true;
      signColumn = true;
    };
    polarity = "dark";
    image = ../../home/wallpapers/nix.png;
  };

  # Don't touch this
  system.stateVersion = "24.05";
}
