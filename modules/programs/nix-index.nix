# nix-index (prebuilt database): command-not-found handler and comma (`, cowsay`)
{inputs, ...}: {
  flake.modules.nixos.nix-index = {
    imports = [inputs.nix-index-database.nixosModules.default];

    programs.nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.nix-index-database.comma.enable = true;
  };
}
