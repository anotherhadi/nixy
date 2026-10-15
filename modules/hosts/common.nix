# Shared by every host: overlays, the impermanence module (inert, see
# system/impermanence.nix) and the few host values features read
# (hosts set them in modules/hosts/<host>/default.nix)
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

      git = {
        name = lib.mkOption {type = lib.types.str;};
        email = lib.mkOption {type = lib.types.str;};
      };

      configDirectory = lib.mkOption {
        type = lib.types.str;
        default = "${config.users.users.${config.nixy.username}.home}/.config/nixos";
        description = "Path of this repository on the host";
      };

      server = {
        domain = lib.mkOption {type = lib.types.str;};
        tunnelId = lib.mkOption {
          type = lib.types.str;
          description = "Cloudflare tunnel exposing the services";
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
