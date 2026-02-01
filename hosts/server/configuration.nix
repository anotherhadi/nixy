{config, ...}: {
  imports = [
    # NixOS module
    ../../nixos/home-manager.nix
    ../../nixos/nix.nix
    ../../nixos/systemd-boot.nix
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ../../nixos/docker.nix
    ../../nixos/amd-graphics.nix

    # NixOS server modules
    ../../server-modules/ssh.nix
    ../../server-modules/firewall.nix
    ../../server-modules/cloudflared.nix
    ../../server-modules/glance
    ../../server-modules/adguardhome.nix
    ../../server-modules/arr.nix
    ../../server-modules/eleakxir.nix
    ../../server-modules/stirling-pdf.nix
    ../../server-modules/cyberchef.nix
    ../../server-modules/linkding.nix
    ../../server-modules/mazanoke.nix
    ../../server-modules/nginx.nix
    ../../server-modules/fail2ban.nix

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix

    ./secrets
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
