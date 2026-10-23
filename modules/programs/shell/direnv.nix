# Direnv loads per-directory environments (.envrc), nix-direnv caches `use flake`
{
  flake.modules.nixos.shell = {
    hjem.extraModules = [
      ({
        lib,
        pkgs,
        ...
      }: {
        packages = [pkgs.direnv];

        xdg.config.files."direnv/direnv.toml".text = ''
          [global]
          log_format = "-"
        '';
        xdg.config.files."direnv/lib/nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";

        zsh.initContent = lib.mkOrder 1100 ''
          eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
        '';
      })
    ];
  };
}
