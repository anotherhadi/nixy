{inputs, nixpkgs, ...}:
nixpkgs.lib.nixosSystem {
  modules = [
    {
      nixpkgs.overlays = [];
      _module.args = {inherit inputs;};
    }
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
    inputs.nix-index-database.nixosModules.default
    ./configuration.nix
  ];
}
