{
  # https://github.com/anotherhadi/nixy
  description = ''
    I have installed the dotfiles from anotherhad and modify dotfiles the way I want. :)
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    stylix.url = "github:danth/stylix";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    nixcord.url = "github:kaylorben/nixcord";
    sops-nix.url = "github:Mic92/sops-nix";
    nixarr.url = "github:rasmus-kirk/nixarr";
    anyrun.url = "github:fufexan/anyrun/launch-prefix";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    swww.url = "github:LGFae/swww";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    LazyVim = {
      url = "github:matadaniel/LazyVim-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    search-nixos-api.url = "github:anotherhadi/search-nixos-api";
  };

  outputs = inputs@{ nixpkgs, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            _module.args = { inherit inputs; };
          }
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          ./hosts/nixos/configuration.nix
        ];
      };
    };
  };
}
