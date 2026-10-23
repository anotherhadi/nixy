# Hjem: user files and packages
# Features add their user side with hjem.extraModules (applied to every hjem user),
# hosts enable their users with hjem.users.<user>.enable = true
#
# Extra per-user options available to every feature:
#   persist.{directories,files}  paths relative to $HOME kept across reboots (impermanence)
#   scripts.<name>               shared script registry, read back with the `scripts` module arg
#                                (those with a bin/ are added to PATH)
#   launcher.<name>              desktop entry ({name, exec}), exec defaults to scripts.<name>
{inputs, ...}: {
  flake.modules.nixos.hjem = {
    config,
    lib,
    ...
  }: let
    users = lib.filterAttrs (_: u: u.enable) config.hjem.users;
  in {
    imports = [inputs.hjem.nixosModules.default];

    hjem = {
      clobberByDefault = true; # Overwrite existing unmanaged files

      extraModules = [
        ({
          config,
          pkgs,
          ...
        }: {
          options = {
            persist = {
              directories = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [];
                description = "Directories (relative to $HOME) to keep across reboots";
              };
              files = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [];
                description = "Files (relative to $HOME) to keep across reboots";
              };
            };

            scripts = lib.mkOption {
              type = lib.types.attrsOf lib.types.package;
              default = {};
              internal = true;
            };

            launcher = lib.mkOption {
              type = lib.types.attrsOf (lib.types.submodule ({name, ...}: {
                options = {
                  name = lib.mkOption {
                    type = lib.types.str;
                    description = "Name shown in the launcher";
                  };
                  exec = lib.mkOption {
                    type = lib.types.str;
                    default = "${config.scripts.${name}}/bin/${name}";
                    defaultText = "the script of the same name";
                  };
                };
              }));
              default = {};
            };

            # User units inherit the session PATH (imported by uwsm) instead of
            # NixOS's minimal default, so what they spawn finds the user's programs
            systemd.services = lib.mkOption {
              type = lib.types.attrsOf (lib.types.submodule {
                environment.PATH = lib.mkForce null;
              });
            };
          };

          config = {
            _module.args.scripts = config.scripts;
            packages =
              # Scripts with a bin/ (writeShellScriptBin, writeShellApplication) go in PATH
              builtins.attrValues (lib.filterAttrs (_: s: s.meta ? mainProgram) config.scripts)
              ++ lib.mapAttrsToList (id: entry:
                pkgs.makeDesktopItem {
                  name = id;
                  desktopName = entry.name;
                  inherit (entry) exec;
                })
              config.launcher;
          };
        })
      ];
    };

    # Home paths declared with persist.* (inert unless the host imports the impermanence aspect)
    environment.persistence."/persist".users = lib.mapAttrs (_: u: {inherit (u.persist) directories files;}) users;
  };
}
