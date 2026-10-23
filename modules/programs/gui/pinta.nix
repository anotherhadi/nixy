# Pinta: image editor
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox;
in {
  flake.modules.nixos.pinta = {
    imports = [aspects.hjem];

    systemd.user.tmpfiles.rules = ["d %h/.config/Pinta 0700 - - -"];

    hjem.extraModules = [
      ({pkgs, ...}: let
        # Sandboxed: no network, ~/Pictures, anything else through the file chooser
        pinta = (mkSandbox pkgs).wrap {
          package = pkgs.pinta;
          gui = true;
          config = {sloth, ...}: {
            flatpak.appId = "com.github.PintaProject.Pinta"; # = its .desktop ID, for files handed over by the portal
            dbus.enable = true; # Portal: file chooser
            bubblewrap.bind.rw = map (d: sloth.concat' sloth.homeDir "/${d}") [".config/Pinta" "Pictures"];
          };
        };
      in {
        packages = [pinta];
      })
    ];
  };
}
