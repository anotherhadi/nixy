# Home-manager configuration for NixOS
{
  inputs,
  pkgs,
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = {
      inherit inputs;
      pkgs-stable = import inputs.nixpkgs-stable {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    };
  };
}
