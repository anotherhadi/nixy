# Chafa: image to ANSI/Unicode converter
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox;
in {
  flake.modules.nixos.chafa = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({pkgs, ...}: {
        # Sandboxed: parses untrusted files, so no network and a read-only home
        packages = [
          ((mkSandbox pkgs).wrap {
            package = pkgs.chafa;
            config = {sloth, ...}: {
              bubblewrap.bind.ro = [sloth.homeDir];
              bubblewrap.bind.rw = ["/tmp"];
            };
          })
        ];
      })
    ];
  };
}
