{
  description =
    "My NixOs dotfiles - Home-manager, hyprland, nixvim, sops, kitty, wofi, waybar, lf, dunst, qutebrowser, tmux, ...";

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
  };

  outputs = inputs@{ nixpkgs, home-manager, sops-nix, hyprland, spicetify-nix
    , nur, nixos-hardware, ... }: {
      nixosConfigurations = {

        nixy = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            { nixpkgs.overlays = [ nur.overlay ]; }
            ./hosts/laptop/configuration.nix
            nixos-hardware.nixosModules.omen-16-n0005ne
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
      };
    };
}
