# Shared by every host
{inputs, ...}: {
  flake.modules.nixos.common = {
    config,
    lib,
    ...
  }: {
    options.nixy = {
      username = lib.mkOption {
        type = lib.types.str;
        description = "Main user of the host";
      };

      configDirectory = lib.mkOption {
        type = lib.types.str;
        default = "${config.users.users.${config.nixy.username}.home}/.config/nixos";
        description = "Path of this repository on the host";
      };

      server = {
        domain = lib.mkOption {type = lib.types.str;};
        proxies = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = {};
          example = {mealie = "http://10.233.16.2:9000";};
          description = "Subdomain -> upstream, served by Caddy on https://<subdomain>.<domain> (modules/server/caddy.nix)";
        };
        rootProxy = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "http://10.233.17.2:8080";
          description = "Upstream served by Caddy on https://<domain> (apex, not covered by the wildcard)";
        };
        networkInterface = lib.mkOption {
          type = lib.types.str;
          description = "WAN interface (NAT for containers, matter-server)";
        };
      };
    };

    imports = [inputs.impermanence.nixosModules.impermanence];

    config.environment.persistence."/persist".enable = lib.mkDefault false;

    config.nixpkgs.overlays = [
      inputs.nur.overlays.default
      # pkgs.unstable.<name>: same package from nixos-unstable
      (final: _: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final.stdenv.hostPlatform) system;
          config.allowUnfree = true;
        };
      })
    ];
  };
}
