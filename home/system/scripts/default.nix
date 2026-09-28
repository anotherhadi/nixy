# Shared script registry: any module that owns a script contributes it here
# (`scripts.<name> = ...`), and every module reads it back via the `scripts`
# module argument.
{
  lib,
  config,
  ...
}: {
  options.scripts = lib.mkOption {
    type = lib.types.attrsOf lib.types.package;
    default = {};
    internal = true;
  };

  config._module.args.scripts = config.scripts;
}
