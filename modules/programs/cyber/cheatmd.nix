# cheatmd: interactive cheatsheets from my Markdown notes
{aspects, ...}: {
  flake.modules.nixos.cheatmd = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({
        config,
        lib,
        pkgs,
        options,
        ...
      }: let
        cheatmd = pkgs.nur.repos.sectui.cheatmd;
      in {
        config = lib.mkMerge [
          {
            packages = [cheatmd];

            xdg.config.files."cheatmd/cheatmd.yaml".text = ''
              path: ${config.directory}/Cyber/notes
            '';
          }

          (lib.optionalAttrs (options ? zsh) {
            zsh.initContent = lib.mkOrder 1100 ''
              if [[ $options[zle] = on ]]; then
                eval "$(${cheatmd}/bin/cheatmd widget zsh)"
              fi
            '';
          })
        ];
      })
    ];
  };
}
