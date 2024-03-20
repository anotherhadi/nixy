{
  description = "Nixy - Hadi's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    waybar.url =
      "github:Alexays/Waybar"; # Fix broken waybar on current nixpkgs-unstable
  };

  outputs = inputs@{ nixpkgs, waybar, home-manager, sops-nix, nixvim
    , spicetify-nix, nixos-hardware, ... }: {
      nixosConfigurations = {
        nixy = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-hardware.nixosModules.omen-16-n0005ne # REMOVE
            ./nixos/configuration.nix
            ./hosts
            { _module.args = { inherit inputs; }; }
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.hadi = import ./home/home.nix; # CHANGEME - replace "hadi"
                extraSpecialArgs = {
                  inherit inputs;
                  inherit spicetify-nix;
                  inherit sops-nix;
                  inherit waybar;
                };
              };
            }
          ];
        };
      };
    };
}
