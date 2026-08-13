{
  inputs,
  nixpkgs,
  pkgs-unstable,
  ...
}:
nixpkgs.lib.nixosSystem {
  modules = [
    {
      nixpkgs.overlays = [
        inputs.nur.overlays.default
      ];
      _module.args = {inherit inputs pkgs-unstable;};
    }
    inputs.nixos-hardware.nixosModules.omen-16-n0005ne
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
    inputs.sops-nix.nixosModules.sops
    inputs.nix-index-database.nixosModules.default
    inputs.helium-browser.nixosModules.default
    inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.disko
    ./disko.nix
    ./configuration.nix
  ];
}
