{lib}: {
  importAll = dir: let
    entries = builtins.readDir dir;
  in
    lib.pipe entries [
      (lib.filterAttrs (name: type: type == "directory"))
      builtins.attrNames
      (builtins.filter (name: builtins.pathExists (dir + "/${name}/default.nix")))
      (map (name: dir + "/${name}"))
    ];
}
