# Nix configuration for NixOS
{inputs, ...}: {
  flake.modules.nixos.nix = {
    config,
    lib,
    ...
  }: {
    # Faster rebuilding
    documentation = {
      doc.enable = false;
      dev.enable = false;
      info.enable = false;
      nixos.enable = false;
    };

    nixpkgs.config = {
      allowUnfree = true;
      allowBroken = false;
    };
    nix = {
      nixPath = ["nixpkgs=${inputs.nixpkgs}"];
      registry = {
        nixpkgs.flake = inputs.nixpkgs;
        nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
      };
      channel.enable = false;
      extraOptions = ''
        warn-dirty = false
      '';
      settings = {
        download-buffer-size = 262144000; # 250 MB (250 * 1024 * 1024)
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };

    programs.nh = {
      enable = true;
      flake = config.nixy.configDirectory;
      clean = {
        enable = lib.mkDefault true;
        dates = "weekly";
        extraArgs = "--keep-since 7d --keep 3";
      };
    };
  };
}
