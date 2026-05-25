{
  inputs,
  nixpkgs,
  ...
}:
nixpkgs.lib.nixosSystem {
  modules = [
    {
      nixpkgs.overlays = [
      ];
      _module.args = {inherit inputs;};
    }
    inputs.nixos-hardware.nixosModules.omen-16-n0005ne
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
    inputs.nix-index-database.nixosModules.default
    inputs.helium-browser.nixosModules.default
    ./configuration.nix
  ];
}
