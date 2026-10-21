# Secrets (sops-nix): age key and tooling, shared by every host
# Hosts only point to their file:  sops.defaultSopsFile = ./_secrets/secrets.yaml;
# Features declare the secrets they use themselves (sops.secrets.<name>), and
# check nixy.secrets.available for the ones only some hosts have
{
  aspects,
  inputs,
  ...
}: {
  flake.modules.nixos.secrets = {
    config,
    lib,
    options,
    pkgs,
    ...
  }: let
    home = config.users.users.${config.nixy.username}.home;
  in {
    imports = [
      inputs.sops-nix.nixosModules.sops
      aspects.common
    ];

    options.nixy.secrets.available = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      readOnly = true;
      description = "Top-level keys of the host's sops file (names are stored in clear)";
      default = lib.optionals options.sops.defaultSopsFile.isDefined (
        lib.pipe config.sops.defaultSopsFile [
          builtins.readFile
          (lib.splitString "\n")
          (map (builtins.match "([a-zA-Z0-9_-]+):.*"))
          (lib.filter (m: m != null))
          (map lib.head)
          (lib.remove "sops")
        ]
      );
    };

    config = {
      sops.age.keyFile = "${home}/.config/sops/age/keys.txt";

      environment.systemPackages = with pkgs; [
        sops
        age
      ];
    };
  };
}
