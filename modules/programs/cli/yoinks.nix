# Yoinks: download videos from YouTube, X, Instagram & 1800+ sites (yt-dlp TUI)
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox;
in {
  flake.modules.nixos.yoinks = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({pkgs, ...}: let
        # Sandboxed: network, but only writes to ~/Downloads and its history
        sandboxed = (mkSandbox pkgs).wrap {
          package = pkgs.unstable.yoinks;
          config = {sloth, ...}: {
            bubblewrap = {
              network = true;
              bind.rw = [
                (sloth.concat' sloth.homeDir "/Downloads")
                (sloth.concat' sloth.homeDir "/.config/yoinks") # history.json
              ];
            };
          };
        };

        # Bind sources must exist, otherwise the app writes into the sandbox's tmpfs and loses it
        yoinks = pkgs.writeShellScriptBin "yoinks" ''
          mkdir -p "$HOME/Downloads" "$HOME/.config/yoinks"
          exec ${sandboxed}/bin/yoinks "$@"
        '';
      in {
        packages = [yoinks];
      })
    ];
  };
}
