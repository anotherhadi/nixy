# TLDR provides simplified, example-based help pages for shell commands
# Pages come from the tldr-pages flake input (offline, no auto-update)
{
  aspects,
  inputs,
  ...
}: {
  flake.modules.nixos.tldr = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({
        lib,
        pkgs,
        options,
        ...
      }: let
        tealdeerCache = pkgs.runCommand "tealdeer-tldr-cache" {} ''
          mkdir -p $out/tldr-pages
          for d in ${inputs.tldr-pages-src}/pages ${inputs.tldr-pages-src}/pages.*; do
            [ -d "$d" ] || continue
            cp -r "$d" "$out/tldr-pages/$(basename "$d")"
          done
          if [ -d "$out/tldr-pages/pages" ] && [ ! -d "$out/tldr-pages/pages.en" ]; then
            mv "$out/tldr-pages/pages" "$out/tldr-pages/pages.en"
          fi
        '';
      in {
        config = lib.mkMerge [
          {
            packages = [pkgs.tealdeer]; # Fast tldr client

            xdg.config.files."tealdeer/config.toml" = {
              generator = (pkgs.formats.toml {}).generate "tealdeer-config.toml";
              value = {
                directories.cache_dir = "${tealdeerCache}";
                updates = {
                  auto_update = false;
                  auto_update_interval_hours = 720;
                };
              };
            };
          }

          (lib.optionalAttrs (options ? zsh) {
            zsh.shellAliases.tldr = "tldr --quiet";
          })
        ];
      })
    ];
  };
}
