# Filen CLI: continuous two-way sync of ~/Cyber/bb and ~/Notes with the Filen drive
# First login is manual: run `filen` alone, log in and save the credentials, then `systemctl --user restart filen-sync`
# The session key lives in the gnome-keyring, so the service waits for the graphical session
{aspects, ...}: {
  flake.modules.nixos.filen = {
    imports = [aspects.hjem];

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
            alias = "bb";
            local = "${config.directory}/Cyber/bb";
            remote = "/Cyber";
            syncMode = "twoWay";
            ignore = [
              "programs/*/recon/" # Raw recon output (webarchive, gau...): ~200M, regenerable
            ];
          }
          {
            alias = "notes";
            local = "${config.directory}/Notes";
            remote = "/Notes";
            syncMode = "twoWay";
          }
        ]);
      in {
        packages = [pkgs.filen-cli];

        systemd.services.filen-sync = {
          description = "Filen sync of ~/Cyber/bb and ~/Notes";
          after = ["graphical-session.target"];
          partOf = ["graphical-session.target"];
          wantedBy = ["graphical-session.target"];
          serviceConfig = {
            ExecStart = "${pkgs.filen-cli}/bin/filen sync ${syncPairs} --continuous";
            Restart = "on-failure";
            RestartSec = 60; # Not logged in yet, or offline
          };
        };

        # Auth config + sync state ({dataDir}/sync)
        persist.directories = [".config/filen-cli"];
      })
    ];
  };
}
