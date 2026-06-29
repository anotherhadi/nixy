# Zoxide is a cd replacement
{pkgs-stable, ...}: {
  programs.zoxide = {
    enable = true;
    package = pkgs-stable.zoxide;
    enableZshIntegration = true;
  };
}
