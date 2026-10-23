# Obsidian: note taking app
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox;
in {
  flake.modules.nixos.obsidian = {
    imports = [aspects.hjem];

    systemd.user.tmpfiles.rules = ["d %h/.config/obsidian 0700 - - -"];

    hjem.extraModules = [
      ({pkgs, ...}: let
        # Sandboxed: network (community plugins), only its config and ~/Notes
        obsidian = (mkSandbox pkgs).wrap {
          package = pkgs.obsidian;
          gui = true;
          config = {sloth, ...}: {
            dbus.enable = true; # Portal: links, file chooser
            bubblewrap = {
              network = true;
              bind.rw = map (d: sloth.concat' sloth.homeDir "/${d}") [".config/obsidian" "Notes"];
            };
          };
        };
      in {
        packages = [obsidian];

        persist.directories = [".config/obsidian"];
      })
    ];
  };
}
