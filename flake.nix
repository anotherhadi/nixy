{
  # https://github.com/anotherhadi/nixy
  description = ''
    Nixy simplifies and unifies the Hyprland ecosystem with a modular, easily customizable setup.
    It provides a structured way to manage your system configuration and dotfiles with minimal effort.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    stylix.url = "github:danth/stylix";
    sops-nix.url = "github:Mic92/sops-nix";
    nvf.url = "github:notashelf/nvf";
    bun2nix.url = "github:nix-community/bun2nix";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    # FIXME: Deleted repo for now
    # eleakxir.url = "github:anotherhadi/eleakxir";
    nixarr.url = "github:rasmus-kirk/nixarr";
    default-creds.url = "github:anotherhadi/default-creds";
    blog.url = "github:anotherhadi/blog";
    awesome-wallpapers.url = "github:anotherhadi/awesome-wallpapers";
    iknowyou.url = "github:anotherhadi/iknowyou";

    # Qutebrowser userscripts (greasemonkey)
    qs-return-youtube-dislike = {
      url = "https://update.greasyfork.org/scripts/436115/Return%20YouTube%20Dislike.user.js";
      flake = false;
    };
    qs-sponsorblock-lite = {
      url = "https://update.greasyfork.org/scripts/560869/SponsorBlock%20Lite.user.js";
      flake = false;
    };
    qs-dont-track-me-google = {
      url = "https://update.greasyfork.org/scripts/428243/Don%27t%20track%20me%20Google.user.js";
      flake = false;
    };
    qs-i-dont-care-about-cookies = {
      url = "https://update.greasyfork.org/scripts/522645/I%20don%27t%20care%20about%20cookies.user.js";
      flake = false;
    };
    qs-tracking-token-stripper = {
      url = "https://github.com/doggy8088/TrackingTokenStripper/raw/refs/heads/master/TrackingTokenStripper.user.js";
      flake = false;
    };
    qs-bypass-paywalls-clean = {
      url = "https://gitflic.ru/project/magnolia1234/bypass-paywalls-clean-filters/blob/raw?file=userscript/bpc.en.user.js";
      flake = false;
    };
    qs-anti-adblock-fuckoff = {
      url = "https://update.greasyfork.org/scripts/397070/Anti-AdBlocker%20Fuckoff.user.js";
      flake = false;
    };
  };

  outputs = inputs @ {nixpkgs, nixpkgs-stable, ...}: let
    system = "x86_64-linux";
    args = {
      inherit inputs nixpkgs system;
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-stable = nixpkgs-stable.legacyPackages.${system};
    };
    merge = nixpkgs.lib.foldl nixpkgs.lib.recursiveUpdate {};
  in
    merge [
      (import ./home/programs/nvf/flake.nix args)
      (import ./home/programs/group/flake.nix args)
      {
        nixosConfigurations = {
          h-laptop = import ./hosts/laptop/flake.nix args;
          h-work = import ./hosts/work/flake.nix args;
          jack = import ./hosts/server/flake.nix args;
        };
      }
    ];
}
