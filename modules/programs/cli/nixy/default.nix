# Nixy is a simple script that I use to manage my NixOS system. It's a simple script that provides a menu to rebuild, test, update, collect garbage, clean boot menu, etc.
{aspects, ...}: {
  perSystem = {pkgs, ...}: {
    packages.nixy = pkgs.callPackage ./_package.nix {
      configDirectory = "$HOME/.config/nixos";
    };
  };

  flake.modules.nixos.nixy = {config, ...}: {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({pkgs, ...}: {
        packages = [
          (pkgs.callPackage ./_package.nix {
            inherit (config.nixy) configDirectory;
          })
        ];
      })
    ];
  };
}
