{
  # https://github.com/anotherhadi/nixy
  description = ''
    Nixy simplifies and unifies the Hyprland ecosystem with a modular, easily customizable setup.
    It provides a structured way to manage your system configuration and dotfiles with minimal effort.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nvf.url = "github:notashelf/nvf";
    nvf-config = {
      url = "path:./home/programs/tui/nvf";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.nvf.follows = "nvf";
    };
    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    notashelf-tuigreet = {
      url = "github:NotAShelf/tuigreet";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium-browser = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Server
    nixarr.url = "github:rasmus-kirk/nixarr";
    default-creds.url = "github:anotherhadi/default-creds";
    blog.url = "github:anotherhadi/blog";
    awesome-wallpapers.url = "github:anotherhadi/awesome-wallpapers";
    iknowyou.url = "github:anotherhadi/iknowyou";
  };

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-stable,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    args = {
      inherit
        inputs
        nixpkgs
        system
        pkgs
        ;
      pkgs-stable = nixpkgs-stable.legacyPackages.${system};
    };
    merge = nixpkgs.lib.foldl nixpkgs.lib.recursiveUpdate {};
  in
    merge [
      (import ./home/programs/tui/nixy/flake.nix args)
      {
        formatter.${system} = pkgs.alejandra;
        packages.${system}.nvim = inputs.nvf-config.packages.${system}.nvim;
        apps.${system}.nvim = inputs.nvf-config.apps.${system}.nvim;
        nixosConfigurations = {
          h-laptop = import ./hosts/laptop/flake.nix args;
          h-work = import ./hosts/work/flake.nix args;
          jack = import ./hosts/server/flake.nix args;
        };
      }
    ];
}
