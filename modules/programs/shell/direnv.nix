# Direnv loads per-directory environments
{
  flake.modules.nixos.shell = {
    hjem.extraModules = [
      ({
        config,
        lib,
        pkgs,
        ...
      }: {
        packages = [pkgs.direnv];

        # Silent, errors still shown: a filter that matches no message. The documented
        xdg.config.files."direnv/direnv.toml".text = ''
          [global]
          log_filter = "^$"

          [whitelist]
          prefix = ["${config.directory}/Cyber/programs"]
        '';
        xdg.config.files."direnv/lib/nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";

        zsh.initContent = lib.mkOrder 1100 ''
          eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
        '';
      })
    ];
  };
}
