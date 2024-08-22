{ config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./variables.nix

    ../modules/grub.nix
    ../modules/timezone.nix
    ../modules/utils.nix
    ../modules/users.nix
    ../modules/zsh.nix
    ../modules/nix.nix
    ../modules/auto-upgrade.nix
    ../modules/home-manager.nix

    # internal
    ./modules/internal/security.nix
    ./modules/internal/openssh.nix
    # ./modules/internal/adguard.nix # TODO
    # ./modules/internal/cockpit.nix

    # exposed
    # ./modules/exposed/ntfy-sh.nix
    ./modules/exposed/tailscale.nix
    ./modules/exposed/kuma.nix
    ./modules/exposed/cloudflare-dyndns.nix
    ./modules/exposed/nginx.nix
    ./modules/exposed/nextcloud.nix
    ./modules/exposed/vaultwarden.nix
    ./modules/www

    ./modules/jackflix

    ./secrets
  ];

  virtualisation.docker.enable = true;

  networking.networkmanager.enable = true;

  home-manager.users."${config.var.username}" = import ./home.nix;

  users.users.${config.var.username} = {
    openssh.authorizedKeys.keys = [ config.var.sshPublicKey ];
  };

  # Don't touch this
  system.stateVersion = "24.05";
}
