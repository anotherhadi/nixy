# Secrets (sops-nix): age key and tooling, shared by every host
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
      # TODO: this user-readable key decrypts every host's secrets: any
      # process running as the user can steal it.
      sops.age.keyFile = "${home}/.config/sops/age/keys.txt";

      environment.systemPackages = with pkgs; [
        sops
        age
      ];
    };
  };
}
