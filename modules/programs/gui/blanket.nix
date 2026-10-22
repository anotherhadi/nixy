# Blanket: listen to different sounds
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox;
in {
  flake.modules.nixos.blanket = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({pkgs, ...}: let
        # Sandboxed: no network, no files, audio only
        blanket = (mkSandbox pkgs).wrap {
          package = pkgs.blanket;
          gui = true;
          config = _: {
            flatpak.appId = "com.rafaelmardojai.Blanket"; # = its .desktop ID, for files handed over by the portal
            dbus.enable = true;
            bubblewrap.sockets = {
              pipewire = true;
              pulse = true;
            };
          };
        };
      in {
        packages = [blanket];
      })
    ];
  };
}
