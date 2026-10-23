# Offensive security toolbox
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
      aspects.veille-vulnx
      aspects.findings
      aspects.cheatmd
    ];

    sops.secrets = {
      subfinder-providers = providers "subfinder";
      urlfinder-providers = providers "urlfinder";
    };

    hjem.extraModules = [
      ({pkgs, ...}: let
        wordlists-fetch = import ./_wordlists.nix {inherit pkgs;};
      in {
        packages = import ./_pkgs.nix {inherit pkgs;} ++ [wordlists-fetch];

        files = {
          # Open source list of default credentials
          ".cache/default-creds".source = inputs.default-creds;
        };

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

        # ProjectDiscovery tools (nuclei, httpx, subfinder...) check for updates on every run
        environment.sessionVariables = {
          DISABLE_UPDATE_CHECK = "true";
          NUCLEI_TEMPLATES_DIR = "${home}/.nuclei-templates";
        };

        persist.directories = [
          "Cyber"
          ".config/nuclei"
          ".nuclei-templates"
        ];
        persist.files = [
          ".pdcp/credentials.yaml" # ProjectDiscovery API key (vulnx auth)
        ];
      })
    ];
  };
}
