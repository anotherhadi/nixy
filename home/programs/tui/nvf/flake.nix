{
  description = "Hadi's NVF Neovim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = {
    self,
    nixpkgs,
    nvf,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
    forAllSystems = f: nixpkgs.lib.genAttrs systems f;
    modules = [
      ./options.nix
      ./languages.nix
      ./picker.nix
      ./snacks.nix
      ./keymaps.nix
      ./utils.nix
      ./mini.nix
    ];
  in {
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      nvim = (nvf.lib.neovimConfiguration {inherit pkgs modules;}).neovim;
    in {
      inherit nvim;
      default = nvim;
    });

    apps = forAllSystems (system: let
      nvim = {
        type = "app";
        program = "${self.packages.${system}.nvim}/bin/nvim";
      };
    in {
      inherit nvim;
      default = nvim;
    });

    homeManagerModules = rec {
      nvim = {
        imports = [
          nvf.homeManagerModules.default
          ./default.nix
        ];
      };
      default = nvim;
    };

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
