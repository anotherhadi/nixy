# GNOME Text Editor: backup GUI text editor
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox;
in {
  flake.modules.nixos.gnome-text-editor = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({pkgs, ...}: let
        # Sandboxed like elio: no network, whole home, NixOS config read-only
        gnome-text-editor = (mkSandbox pkgs).wrap {
          package = pkgs.gnome-text-editor;
          gui = true;
          config = {sloth, ...}: {
            flatpak.appId = "org.gnome.TextEditor"; # = its .desktop ID, for files handed over by the portal
            dbus.enable = true; # Portal: file chooser
            bubblewrap = {
              bind.rw = [sloth.homeDir];
              bind.ro = [(sloth.concat' sloth.homeDir "/.config/nixos")];
            };
          };
        };
      in {
        packages = [gnome-text-editor];
      })
    ];
  };
}
