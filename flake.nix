{
  # https://github.com/anotherhadi/nixy
  description = ''
    Nixy is a NixOS configuration with home-manager, secrets and custom theming all in one place.
    It's a simple way to manage your system configuration and dotfiles.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    plugin-markdown = {
      url = "github:MeanderingProgrammer/render-markdown.nvim";
      flake = false;
    };
    nixy-wallpapers = {
      url = "github:anotherhadi/nixy-wallpapers";
      flake = false;
    };
    # FIXME: Solve build error until this is fixed
    stylix.url = "github:danth/stylix/32dba263f63f830d2f11fb079f8796cdec73d3ce";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
  };

  outputs = inputs@{ nixpkgs, ... }: {
    nixosConfigurations = {
      nixy = # CHANGEME
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            {
              nixpkgs.overlays = [ inputs.hyprpanel.overlay ];
              _module.args = { inherit inputs; };
            }
            inputs.nixos-hardware.nixosModules.omen-16-n0005ne # CHANGEME
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            ./hosts/laptop/configuration.nix # CHANGEME
          ];
        };
    };
  };
}
