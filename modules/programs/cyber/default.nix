# Offensive security toolbox: tools, wordlists and a dedicated browser (librewolf.nix)
{
  aspects,
  inputs,
  ...
}: {
  flake.modules.nixos.cybersecurity = {
    config,
    lib,
    ...
  }: let
    username = config.nixy.username;
    home = config.users.users.${username}.home;
    # API keys of the recon tools, on hosts whose sops file has them
    providers = tool:
      lib.mkIf (builtins.elem "${tool}-providers" config.nixy.secrets.available) {
        owner = username;
        mode = "0400";
        path = "${home}/.config/${tool}/provider-config.yaml";
      };
  in {
    imports = [
      aspects.hjem
      aspects.secrets
    ];

    sops.secrets = {
      subfinder-providers = providers "subfinder";
      urlfinder-providers = providers "urlfinder";
    };

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
          path: ${config.directory}/Cyber/_notes
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
          "Cyber"
        ];
        persist.files = [
          ".pdcp/credentials.yaml" # ProjectDiscovery API key (vulnx auth)
        ];
      })
    ];
  };
}
