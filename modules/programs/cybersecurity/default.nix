# Offensive security toolbox: tools, wordlists and a dedicated browser (librewolf.nix)
{
  aspects,
  inputs,
  ...
}: {
  flake.modules.nixos.cybersecurity = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({
        config,
        pkgs,
        ...
      }: let
        wordlists-fetch = import ./_wordlists.nix {inherit pkgs;};
      in {
        packages = import ./_pkgs.nix {inherit pkgs;} ++ [wordlists-fetch];

        files = {
          # Open source list of default credentials
          ".cache/default-creds".source = inputs.default-creds;
        };

        xdg.config.files."cheatmd/cheatmd.yaml".text = ''
          path: ${config.directory}/Cyber/bb/_notes
        '';

        systemd.services.wordlists-fetch = {
          description = "Download missing wordlists into ~/Cyber/wordlists";
          wantedBy = ["default.target"];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${wordlists-fetch}/bin/wordlists-fetch";
            Restart = "on-failure";
            RestartSec = 60; # Offline at login
          };
        };

        persist.directories = [
          "Cyber/bb"
          "Cyber/certs"
          "Cyber/wordlists"
        ];
      })
    ];
  };
}
