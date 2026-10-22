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
        # Sandboxed like elio: no network, whole home, NixOS config read-only
        # Everything thunar opens inherits the sandbox
        thunar = (mkSandbox pkgs).wrap {
          package = pkgs.thunar;
          gui = true;
          config = {sloth, ...}: {
            dbus = {
              enable = true;
              policies."org.xfce.Xfconf" = "talk"; # Settings
            };
            bubblewrap = {
              bind.rw = [sloth.homeDir];
              bind.ro = [(sloth.concat' sloth.homeDir "/.config/nixos")];
            };
          };
        };
      in {
        packages = [thunar];
      })
    ];
  };
}
