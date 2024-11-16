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
    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    nixy-wallpapers = {
      url = "github:anotherhadi/nixy-wallpapers";
      flake = false;
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprpolkitagent.url = "github:hyprwm/hyprpolkitagent";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    stylix.url = "github:danth/stylix";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    pia = {
      url = "github:Fuwn/pia.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ nixpkgs, ... }: {
    nixosConfigurations = {
      nixy = # CHANGEME: This should match the 'hostname' in your variables.nix file
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            {
              nixpkgs.overlays = [
                inputs.hyprpanel.overlay
                # FIXME: Temp fix
                (final: prev: {
                  matugen = final.rustPlatform.buildRustPackage rec {
                    pname = "matugen";
                    version = "2.4.0";

                    src = final.fetchFromGitHub {
                      owner = "InioX";
                      repo = "matugen";
                      rev = "refs/tags/v${version}";
                      hash =
                        "sha256-l623fIVhVCU/ylbBmohAtQNbK0YrWlEny0sC/vBJ+dU=";
                    };

                    cargoHash =
                      "sha256-FwQhhwlldDskDzmIOxhwRuUv8NxXCxd3ZmOwqcuWz64=";

                    meta = {
                      description = "Material you color generation tool";
                      homepage = "https://github.com/InioX/matugen";
                      changelog =
                        "https://github.com/InioX/matugen/blob/${src.rev}/CHANGELOG.md";
                      license = final.lib.licenses.gpl2Only;
                      maintainers = with final.lib.maintainers; [ lampros ];
                      mainProgram = "matugen";
                    };
                  };
                })
              ];
              _module.args = { inherit inputs; };
            }
            inputs.nixos-hardware.nixosModules.omen-16-n0005ne # CHANGEME: check https://github.com/NixOS/nixos-hardware
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            inputs.pia.nixosModules."x86_64-linux".default
            ./hosts/laptop/configuration.nix # CHANGEME: change the path to match your host folder
          ];
        };
    };
  };
}
