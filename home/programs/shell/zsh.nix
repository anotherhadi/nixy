{ pkgs, lib, config, ... }: {

  home.packages = with pkgs; [ bat ripgrep tldr ];

  home.sessionPath = [ "$HOME/go/bin" ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    initExtraFirst = ''
      bindkey -e
      ${if config.var.theme.fetch == "neofetch" then
        pkgs.neofetch + "/bin/neofetch"
      else if config.var.theme.fetch == "nerdfetch" then
        "nerdfetch"
      else if config.var.theme.fetch == "pfetch" then
        "echo; ${pkgs.pfetch}/bin/pfetch"
      else
        ""}
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
      vi = "nvim";
      v = "nvim";
      c = "clear";
      clera = "clear";
      celar = "clear";
      e = "exit";
      cd = "z";
      ls = "eza --icons=always --no-quotes";
      tree = "eza --icons=always --tree --no-quotes";
      sl = "ls";
      open = "${pkgs.xdg_utils}/bin/xdg-open";
      icat = "${pkgs.kitty}/bin/kitty +kitten icat";
      note = "vim ~/nextcloud/Notes/index.md";
      wireguard-import = "nmcli connection import type wireguard file";
      neorg = "cd ~/nextcloud/neorg && vim -c ':ZenMode' -c ':Telescope find_files' index.norg";

      # git
      ga = "git add";
      gc = "git commit";
      gcm = "git commit -m";
      gcu = "git commit -am 'Update'";
      gp = "git push";
      gpl = "git pull";
      gs = "git status";
      gd = "git diff";
      gco = "git checkout";
      gcb = "git checkout -b";
      gbr = "git branch";
    };
  };
}
