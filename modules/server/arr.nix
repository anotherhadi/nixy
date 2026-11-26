# *arr is a collection of media management applications.
# See https://github.com/rasmus-kirk/nixarr
# Setup guide: https://nixarr.com/wiki/setup/
{inputs, ...}: {
  flake.modules.nixos.arr = {
    config,
    pkgs,
    ...
  }: let
    username = config.nixy.username;
  in {
    imports = [inputs.nixarr.nixosModules.default];

    # Add my secrets
    sops.secrets = {
      recyclarr = {
        owner = "recyclarr";
        # TODO: too permissive (world-writable), should be 0600/0400
        mode = "0777";
      };
      wireguard-pia = {
        group = "media";
        mode = "0600";
      };
    };

    nixarr = {
      enable = true;

      mediaUsers = [username];
      mediaDir = "/mnt/data/media";
      stateDir = "/mnt/data/.state/nixarr";

      vpn = {
        enable = true;
        wgConf = config.sops.secrets.wireguard-pia.path;
      };

      jellyfin.enable = true;
      seerr = {
        enable = true;
        package = pkgs.unstable.seerr;
      };
      prowlarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
      bazarr.enable = true;
      transmission = {
        enable = true;
        peerPort = 50000;
        extraSettings = {
          trash-original-torrent-files = true;
          rpc-whitelist-enabled = false;
          rpc-host-whitelist-enabled = false;
        };
        vpn.enable = true;
      };
      recyclarr = {
        enable = true;
        configFile = config.sops.secrets.recyclarr.path;
      };
    };

    users.users.jellyfin.extraGroups = [
      "video"
      "render"
    ];

    nixy.server.proxies = {
      media = "http://localhost:8096";
      demandemedia = "http://localhost:5055";
      bazarr = "http://localhost:6767";
      prowlarr = "http://localhost:9696";
      radarr = "http://localhost:7878";
      sonarr = "http://localhost:8989";
      transmission = "http://localhost:9091";
    };
  };
}
