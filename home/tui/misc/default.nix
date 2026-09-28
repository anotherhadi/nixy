{lib, ...}: let
  utils = import ../../lib/utils.nix {inherit lib;};
in {
  imports =
    utils.importAll ./.;
}
