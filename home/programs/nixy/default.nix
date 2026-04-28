# - ## Nixy
#-
#- Nixy is a simple script that I use to manage my NixOS system. It's a simple script that provides a menu to rebuild, test, update, collect garbage, clean boot menu, etc.
#-
#- - `nixy` - UI wizard to manage the system.
#- - `nixy rebuild` - Rebuild the system.
#- - `nixy ...` - ... see the script for more commands.
{
  pkgs,
  config,
  ...
}: let
  inherit (config.var) configDirectory;
  nixy = import ./package.nix {inherit pkgs configDirectory;};
in {home.packages = [nixy];}
