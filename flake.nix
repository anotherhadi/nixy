{
  # https://github.com/anotherhadi/nixy
  description = ''
    Nixy is a NixOS configuration with home-manager, secrets and custom theming all in one place.
    It's a simple way to manage your system configuration and dotfiles.
  '';

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
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs@{ nixpkgs, ... }: {
    nixosConfigurations = {

      nixy = nixpkgs.lib.nixosSystem { # CHANGEME
        system = "x86_64-linux";
        modules = [
          { _module.args = { inherit inputs; }; }
          inputs.nixos-hardware.nixosModules.omen-16-n0005ne # CHANGEME
          inputs.home-manager.nixosModules.home-manager
          ./hosts/laptop/configuration.nix # CHANGEME
        ];
      };

      jack = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          inputs.sops-nix.nixosModules.sops
          ./hosts/server/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [ inputs.nurpkgs.overlay ];
            _module.args = { inherit inputs; };
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."hadi" = import ./hosts/server/home.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };

    };
  };
}
