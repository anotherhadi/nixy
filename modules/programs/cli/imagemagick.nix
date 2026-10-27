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
      ({pkgs, ...}: let
        # Sandboxed: parses untrusted files, so no network and only the current dir
        sandboxed = (mkSandbox pkgs).wrap {
          package = pkgs.imagemagick;
          home = "cwd";
          config = {
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
            bubblewrap.bind.rw = ["/tmp"];
          };
        };

        guarded = pkgs.runCommandLocal "imagemagick-guarded" {} ''
          mkdir -p $out/bin
          for bin in ${sandboxed}/bin/*; do
            name=$(basename "$bin")
            cat > "$out/bin/$name" <<EOF
          #!${pkgs.runtimeShell}
          case "\$PWD" in
            / | "\$HOME")
              echo "$name: refusing to expose \$PWD, run it from a subdirectory" >&2
              exit 1
              ;;
          esac
          exec $bin "\$@"
          EOF
            chmod +x "$out/bin/$name"
          done
        '';
      in {
        packages = [
          (pkgs.symlinkJoin {
            name = "imagemagick-sandboxed";
            paths = [guarded sandboxed];
          })
        ];
      })
    ];
  };
}
