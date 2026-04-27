{inputs, nixpkgs, ...}:
nixpkgs.lib.nixosSystem {
  modules = [
    {_module.args = {inherit inputs;};}
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
    inputs.sops-nix.nixosModules.sops
    inputs.nixarr.nixosModules.default
    # inputs.eleakxir.nixosModules.eleakxir
    inputs.nix-index-database.nixosModules.default
    inputs.default-creds.nixosModules.default
    ./configuration.nix
  ];
}
