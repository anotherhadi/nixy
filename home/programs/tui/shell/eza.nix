# Eza is a ls replacement
{pkgs-stable, ...}: {
  programs.eza = {
    enable = true;
    package = pkgs-stable.eza;
    icons = "auto";

    extraOptions = [
      "--group-directories-first"
      "--no-quotes"
      "--icons=always"
    ];
  };
}
