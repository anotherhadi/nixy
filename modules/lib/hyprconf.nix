# Hyprlang helpers (Hyprland, hyprlock, hypridle, hyprpaper configs)
# toHyprconf is home-manager's generator (lib.hm.generators.toHyprconf)
# Usage, from any flake-parts module:
#   config.flake.lib.toHyprconf {attrs = {...};}
#   lib.types: config.flake.lib.hyprconfType (mergeable settings, like home-manager's)
{lib, ...}: {
  flake.lib = {
    hyprconfType = let
      valueType = with lib.types;
        nullOr (oneOf [bool int float str path (attrsOf valueType) (listOf valueType)])
        // {description = "Hyprland configuration value";};
    in
      valueType;

    toHyprconf = {
      attrs,
      indentLevel ? 0,
      importantPrefixes ? ["$" "bezier" "curve" "name" "output"],
    }: let
      inherit
        (lib)
        all
        concatMapStringsSep
        concatStrings
        concatStringsSep
        filterAttrs
        foldl
        generators
        hasPrefix
        isAttrs
        isList
        mapAttrsToList
        replicate
        attrNames
        ;

      initialIndent = concatStrings (replicate indentLevel "  ");

      toHyprconf' = indent: attrs: let
        isImportantField = n: _:
          foldl (acc: prev:
            if hasPrefix prev n
            then true
            else acc)
          false
          importantPrefixes;
        importantFields = filterAttrs isImportantField attrs;
        withoutImportantFields = fields: removeAttrs fields (attrNames importantFields);

        allSections = filterAttrs (_n: v: isAttrs v || isList v) attrs;
        sections = withoutImportantFields allSections;

        mkSection = n: attrs:
          if isList attrs
          then let
            separator =
              if all isAttrs attrs
              then "\n"
              else "";
          in (concatMapStringsSep separator (a: mkSection n a) attrs)
          else if isAttrs attrs
          then ''
            ${indent}${n} {
            ${toHyprconf' "  ${indent}" attrs}${indent}}
          ''
          else toHyprconf' indent {${n} = attrs;};

        mkFields = generators.toKeyValue {
          listsAsDuplicateKeys = true;
          inherit indent;
        };

        allFields = filterAttrs (_n: v: !(isAttrs v || isList v)) attrs;
        fields = withoutImportantFields allFields;
      in
        mkFields importantFields
        + concatStringsSep "\n" (mapAttrsToList mkSection sections)
        + mkFields fields;
    in
      toHyprconf' initialIndent attrs;
  };
}
