# Caddy reverse proxy
{
  flake.modules.nixos.caddy = {
    config,
    lib,
    pkgs,
    ...
  }: let
    domain = config.nixy.server.domain;

    tls = ''
      tls {
        dns cloudflare {env.CF_API_TOKEN}
        # Look the zone up on public resolvers, not the NetBird/AdGuard ones (local hadi.icu zone)
        resolvers 1.1.1.1 1.0.0.1
        # Querying Cloudflare's nameservers from here fails (EOF): skip the propagation check,
        # wait a bit and let Let's Encrypt verify the TXT record itself
        propagation_delay 30s
        propagation_timeout -1
      }
    '';

    route = name: upstream: ''
      @${name} host ${name}.${domain}
      handle @${name} {
        reverse_proxy ${upstream}
      }
    '';
  in {
    sops.secrets.caddy-env.restartUnits = ["caddy.service"];

    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = ["github.com/caddy-dns/cloudflare@v0.2.4"];
        hash = "sha256-tubXIDCJnO2mvdnPlZclwDhNGaeeYLSt7lnni3+pXDo=";
      };
      environmentFile = config.sops.secrets.caddy-env.path;

      virtualHosts."*.${domain}".extraConfig = ''
        ${tls}

        ${lib.concatStrings (lib.mapAttrsToList route config.nixy.server.proxies)}
        handle {
          respond 404
        }
      '';

      virtualHosts.${domain} = lib.mkIf (config.nixy.server.rootProxy != null) {
        extraConfig = ''
          ${tls}
          reverse_proxy ${config.nixy.server.rootProxy}
        '';
      };
    };
  };
}
