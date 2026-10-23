# Filen CLI: continuous two-way sync
# First login is manual:
# run `filen` alone, log in and save the credentials, then `systemctl --user restart filen-sync`
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox;
in {
  flake.modules.nixos.filen = {
    imports = [aspects.hjem];

    systemd.user.tmpfiles.rules = ["d %h/.config/filen-cli 0700 - - -"];

    hjem.extraModules = [
      ({
        config,
        pkgs,
        ...
      }: let
        # Same schema as {dataDir}/syncPairs.json, see `filen help sync`
        # ignore: gitignore syntax, relative to `local` (a .filenignore at the root of `local` also works)
        syncPairs = pkgs.writeText "filen-sync-pairs.json" (builtins.toJSON [
          {
            alias = "cyber";
            local = "${config.directory}/Cyber";
            remote = "/Cyber";
            syncMode = "twoWay";
            ignore = [
              "programs/*/recon/" # Raw recon output
              "wordlists"
            ];
          }
          {
            alias = "notes";
            local = "${config.directory}/Notes";
            remote = "/Notes";
            syncMode = "twoWay";
          }
        ]);

        # Sandboxed: only the synced dirs and its own data dir are visible
        filen = (mkSandbox pkgs).wrap {
          package = pkgs.filen-cli;
          config = {sloth, ...}: {
            dbus = {
              enable = true;
              policies."org.freedesktop.secrets" = "talk"; # Session key, stored in the gnome-keyring
            };
            bubblewrap = {
              network = true;
              bind.rw = [
                (sloth.concat' sloth.homeDir "/.config/filen-cli") # Auth config + sync state
                (sloth.concat' sloth.homeDir "/Cyber")
                (sloth.concat' sloth.homeDir "/Notes")
              ];
              tmpfs = ["/tmp"]; # Bun extracts the keyring native module there before loading it
            };
          };
        };
      in {
        packages = [filen];

        systemd.services.filen-sync = {
          description = "Filen sync of ~/Cyber and ~/Notes";
          after = ["graphical-session.target"];
          partOf = ["graphical-session.target"];
          wantedBy = ["graphical-session.target"];
          unitConfig.ConditionPathIsDirectory = [
            "${config.directory}/Cyber"
            "${config.directory}/Notes"
          ];
          serviceConfig = {
            ExecStart = "${filen}/bin/filen sync ${syncPairs} --continuous";
            Restart = "on-failure";
            RestartSec = 60; # Not logged in yet, or offline
          };
        };

        persist.directories = [".config/filen-cli"];
      })
    ];
  };
}
