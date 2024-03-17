{ pkgs, lib, config, ... }: {

  home.packages = with pkgs; [ eza bat ripgrep tldr ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    initExtraFirst = ''
      bindkey -e
      ${pkgs.neofetch}/bin/neofetch
    '';

    history = {
      ignoreDups = true;
      save = 1000000;
      size = 1000000;
    };

    profileExtra = lib.optionalString (config.home.sessionPath != [ ]) ''
      export PATH="$PATH''${PATH:+:}${
        lib.concatStringsSep ":" config.home.sessionPath
      }"
    '';

    shellAliases = {
      vim = "nvim";
      v = "nvim";
      c = "clear";
      clera = "clear";
      celar = "clear";
      e = "exit";
      cd = "z";
      ls = "${pkgs.eza}/bin/eza --icons=always";
      sl = "ls";
      open = "${pkgs.xdg_utils}/bin/xdg-open";
      icat = "${pkgs.kitty}/bin/kitty +kitten icat";
    };
  };
}
