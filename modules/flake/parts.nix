# Flake-wide flake-parts settings
{
  inputs,
  config,
  lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.modules # flake.modules.<class>.<name>
  ];

  # Helpers shared between modules, defined from several files (lib/*.nix)
  options.flake.lib = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = {};
  };

  config = {
    _module.args.aspects =
      lib.mapAttrs (name: module: {
        key = "nixy#aspects.${name}";
        imports = [module];
      })
      config.flake.modules.nixos;

    systems = ["x86_64-linux" "aarch64-linux"];
    perSystem = {pkgs, ...}: {
      formatter = pkgs.alejandra;
    };
  };
}
