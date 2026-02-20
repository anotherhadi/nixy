{
  # https://github.com/anotherhadi/nixy
  description = ''
    Nixy simplifies and unifies the Hyprland ecosystem with a modular, easily customizable setup.
    It provides a structured way to manage your system configuration and dotfiles with minimal effort.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # FIXME: This is a temporary fix: External monitor doesn't work anymore
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=b1d1c9843f1977f80ca5c9e9ea01d3848e233fbe";
    stylix.url = "github:danth/stylix";
    nixcord.url = "github:kaylorben/nixcord";
    sops-nix.url = "github:Mic92/sops-nix";
    nvf.url = "github:notashelf/nvf";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-cli = {
      url = "github:caelestia-dots/cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Server
    eleakxir.url = "github:anotherhadi/eleakxir";
    nixarr.url = "github:rasmus-kirk/nixarr";
  };

  outputs = inputs @ {nixpkgs, ...}: {
    nixosConfigurations = {
      nixy =
        # CHANGEME: This should match the 'hostname' in your variables.nix file
        nixpkgs.lib.nixosSystem {
          modules = [
            {
              nixpkgs.overlays = [];
              _module.args = {
                inherit inputs;
              };
            }
            inputs.nixos-hardware.nixosModules.omen-16-n0005ne # CHANGEME: check https://github.com/NixOS/nixos-hardware
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            ./hosts/laptop/configuration.nix # CHANGEME: change the path to match your host folder
          ];
        };

      pph = nixpkgs.lib.nixosSystem {
        modules = [
          {
            nixpkgs.overlays = [];
            _module.args = {
              inherit inputs;
            };
          }
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          ./hosts/pph/configuration.nix
        ];
      };
      # Jack is my server
      jack = nixpkgs.lib.nixosSystem {
        modules = [
          {_module.args = {inherit inputs;};}
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.sops-nix.nixosModules.sops
          inputs.nixarr.nixosModules.default
          inputs.eleakxir.nixosModules.eleakxir
          ./hosts/server/configuration.nix
        ];
      };
    };
  };
}
