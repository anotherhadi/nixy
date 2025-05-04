{ config, ... }: {
  imports = [
    ../../nixos/home-manager.nix
    ../../nixos/nix.nix
    ../../nixos/systemd-boot.nix
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ../../nixos/docker.nix
    ../../nixos/tailscale.nix

    ../../server-modules/ssh.nix
    ../../server-modules/bitwarden.nix
    ../../server-modules/firewall.nix
    ../../server-modules/nginx.nix
    ../../server-modules/nextcloud.nix
    ../../server-modules/glance.nix
    ../../server-modules/adguardhome.nix
    ../../server-modules/hoarder.nix
    ../../server-modules/arr.nix
    # ../../server-modules/mealie.nix # FIXME: Broken on unstable
    # ../../server-modules/meilisearch.nix
    ../../server-modules/search-nixos-api.nix
    # ../../server-modules/headscale.nix

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix

    ./secrets
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
