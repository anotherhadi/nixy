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
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  };

  outputs =
    inputs@{ nixpkgs, home-manager, sops-nix, hyprland, spicetify-nix, ... }: {
      nixosConfigurations = {

        nixy = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/laptop/configuration.nix
            ./hosts/laptop/fonts.nix
            ./hosts/laptop/tuigreet.nix
            { _module.args = { inherit inputs; }; }
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users."hadi" = import ./home/laptop.nix; # CHANGE ME
                extraSpecialArgs = {
                  inherit inputs;
                  inherit spicetify-nix;
                  inherit sops-nix;
                  inherit hyprland;
                };
              };
            }
          ];
        };

        heaven = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/server/configuration.nix
            { _module.args = { inherit inputs; }; }
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users."hadi" = import ./home/server.nix; # CHANGE ME
                extraSpecialArgs = {
                  inherit inputs;
                  inherit sops-nix;
                };
              };
            }
          ];
        };

      };
    };
}
