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
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    nurpkgs.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
  };

  outputs = inputs@{ nixpkgs, ... }: {
    nixosConfigurations = {

      nixy = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/laptop/configuration.nix
          inputs.nixos-hardware.nixosModules.omen-16-n0005ne
          inputs.home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays =
              [ inputs.nurpkgs.overlay inputs.neorg-overlay.overlays.default ];
            _module.args = { inherit inputs; };
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."hadi" = import ./hosts/laptop/home.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
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
