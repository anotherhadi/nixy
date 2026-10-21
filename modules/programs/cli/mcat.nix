# Mcat: cat command for documents / images / videos and more
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox;
in {
  flake.modules.nixos.mcat = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({pkgs, ...}: {
        # Sandboxed: parses untrusted files, so no network and a read-only home
        packages = [
          ((mkSandbox pkgs).wrap {
            package = pkgs.mcat;
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
