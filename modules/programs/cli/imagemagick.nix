# ImageMagick: image manipulation tool
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox;
in {
  flake.modules.nixos.imagemagick = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({pkgs, ...}: {
        # Sandboxed: writes wherever asked, but no network and secrets hidden
        packages = [
          ((mkSandbox pkgs).wrap {
            package = pkgs.imagemagick;
            config = {sloth, ...}: {
              # Aliases are symlinks to magick, so each one needs its own sandboxed entrypoint
              app.extraEntrypoints = map (bin: "/bin/${bin}") [
                "animate"
                "compare"
                "composite"
                "conjure"
                "convert"
                "display"
                "identify"
                "import"
                "magick-script"
                "mogrify"
                "montage"
                "stream"
              ];
              bubblewrap.bind.rw = [sloth.homeDir "/tmp"];
            };
          })
        ];
      })
    ];
  };
}
