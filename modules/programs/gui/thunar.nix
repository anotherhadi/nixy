# Thunar: backup GUI file manager
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox;
in {
  flake.modules.nixos.thunar = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({pkgs, ...}: let
        # Sandboxed: no network, whole home, NixOS config read-only
        thunar = (mkSandbox pkgs).wrap {
          package = pkgs.thunar;
          gui = true;
          home = "rw";
          config = {
            dbus = {
              enable = true;
              policies."org.xfce.Xfconf" = "talk"; # Settings
            };
          };
        };
      in {
        packages = [thunar];
      })
    ];
  };
}
