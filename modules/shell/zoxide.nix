# Zoxide is a cd replacement
{
  flake.modules.nixos.shell = {
    hjem.extraModules = [
      ({
        lib,
        pkgs,
        ...
      }: {
        packages = [pkgs.zoxide];
        zsh.shellAliases.cd = "z";
        # Last, after every other chpwd hook (see `zoxide doctor`)
        zsh.initContent = lib.mkOrder 2000 ''
          eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
        '';
      })
    ];
  };
}
