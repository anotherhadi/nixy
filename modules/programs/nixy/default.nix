# - ## Nixy
#-
#- Nixy is a simple script that I use to manage my NixOS system. It's a simple script that provides a menu to rebuild, test, update, collect garbage, clean boot menu, etc.
#-
#- - `nixy` - UI wizard to manage the system.
#- - `nixy rebuild` - Rebuild the system.
#- - `nixy ...` - ... see the script for more commands.
{aspects, ...}: {
  perSystem = {pkgs, ...}: {
    packages.nixy = import ./_package.nix {
      inherit pkgs;
      configDirectory = "$HOME/.config/nixos";
    };
  };

  flake.modules.nixos.nixy = {config, ...}: {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({pkgs, ...}: {
        packages = [
          (import ./_package.nix {
            inherit pkgs;
            inherit (config.nixy) configDirectory;
          })
        ];
      })
    ];
  };
}
