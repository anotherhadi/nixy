# - ## Nixy
#-
#- Nixy is a simple script that I use to manage my NixOS system. It's a simple script that provides a menu to rebuild, test, update, collect garbage, clean boot menu, etc.
#-
#- - `nixy` - UI wizard to manage the system.
#- - `nixy rebuild` - Rebuild the system.
#- - `nixy ...` - ... see the script for more commands.
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.programs.nixy = {
    enable = lib.mkEnableOption "nixy";
    configDirectory = lib.mkOption {
      type = lib.types.str;
      default = "$HOME/.config/nixos";
      description = "Path to the NixOS configuration directory";
    };
  };

  config = lib.mkIf config.programs.nixy.enable {
    home.packages = [
      (import ./package.nix {
        inherit pkgs;
        inherit (config.programs.nixy) configDirectory;
      })
    ];
  };
}
