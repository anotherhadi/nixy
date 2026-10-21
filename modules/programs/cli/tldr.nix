# TLDR provides simplified, example-based help pages for shell commands
{
  aspects,
  inputs,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox;
in {
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

        # Sandboxed: no network, no D-Bus, only its own (read-only) config.
        # The page cache lives in the store, so nothing needs to be writable.
        tealdeer = (mkSandbox pkgs).wrap {
          package = pkgs.tealdeer;
          config = {sloth, ...}: {
            bubblewrap.bind.ro = [(sloth.concat' sloth.xdgConfigHome "/tealdeer")];
          };
        };
      in {
        config = lib.mkMerge [
          {
            packages = [tealdeer];

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
