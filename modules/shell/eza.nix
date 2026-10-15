# Eza is a ls replacement
{
  flake.modules.nixos.shell = {
    hjem.extraModules = [
      ({pkgs, ...}: {
        packages = [pkgs.eza];

        zsh.initContent = ''
          compdef eza=ls
        '';

        zsh.shellAliases = {
          eza = "eza --icons auto --group-directories-first --no-quotes --icons=always";
          ls = "eza --icons=always --no-quotes";
          tree = "eza --icons=always --tree --no-quotes";
          ll = "eza -l";
          la = "eza -a";
          lt = "eza --tree";
          lla = "eza -la";
        };
      })
    ];
  };
}
