# Eza is a ls replacement
{
  programs.zsh.initContent = ''
    compdef eza=ls
  '';
  programs.eza = {
    enable = true;
    icons = "auto";

    extraOptions = [
      "--group-directories-first"
      "--no-quotes"
      "--icons=always"
    ];
  };
}
