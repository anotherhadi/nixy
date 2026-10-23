# imv: image viewer, default for images
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox mime;
in {
  flake.modules.nixos.imv = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({pkgs, ...}: let
        # Sandboxed: no network, no D-Bus, reads the user dirs, writes nothing
        imv = (mkSandbox pkgs).wrap {
          package = pkgs.imv;
          gui = true;
          config = {sloth, ...}: {
            # bin/imv is a script picking imv-wayland/imv-x11: wrap the real binary, nixpak rewrites the script
            app.binPath = "bin/imv-wayland";
            flatpak = {
              appId = "io.github.imv";
              desktopFile = "imv-dir.desktop";
            };
            bubblewrap = {
              bind.ro = map (d: sloth.concat' sloth.homeDir "/${d}") [
                # XDG user dirs (desktop/user-dirs.nix)
                "Cyber"
                "Documents"
                "Downloads"
                "Music"
                "Notes"
                "Pictures"
                "Projects"
                "Videos"
              ];
            };
          };
        };
      in {
        packages = [imv];

        xdg.mime-apps = mime.defaultFor "io.github.imv.desktop" mime.types.image;
      })
    ];
  };
}
