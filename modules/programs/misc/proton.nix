# Proton tools
# TODO: proton-pass-agent ?
{aspects, ...}: {
  flake.modules.nixos.proton = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({
        config,
        lib,
        pkgs,
        options,
        ...
      }: {
        config = lib.mkMerge [
          {
            packages = [
              # TODO: config + desktop file
              pkgs.nur.repos.anotherhadi.proton-vpn-tui
              pkgs.proton-vpn-cli
            ];
          }
        ];
      })
    ];
  };
}
