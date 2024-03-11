{ pkgs, lib, config, ... }: {

  home.packages = with pkgs; [ eza bat ripgrep tldr ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    history = {
      ignoreDups = true;
      save = 1000000;
      size = 1000000;
    };


    profileExtra = lib.optionalString (config.home.sessionPath != [ ]) ''
      export PATH="$PATH''${PATH:+:}${lib.concatStringsSep ":" config.home.sessionPath}"
    '';

    shellAliases = {
      vim = "nvim";
      v = "nvim";
      c = "clear";
      clera = "clear";
      celar = "clear";
      e = "exit";
      cd = "z";
      ls = "eza --icons";
      open = "xdg-open";
      icat = "kitty +kitten icat";
    };
  };
}
