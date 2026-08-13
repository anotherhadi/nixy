# My shell configuration
{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    bat
    ripgrep
  ];

  home = {
    sessionPath = ["$HOME/go/bin"];
    sessionVariables = {
      COLORTERM = "truecolor";
      MANPAGER = "bat -l man -p";
    };
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    plugins = [
      {
        name = "zsh-vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];

    history = {
      ignoreDups = true;
      findNoDups = true;
      expireDuplicatesFirst = true;
      ignoreSpace = true;
      append = true;
      save = 10000;
      size = 10000;
    };

    setOptions = [
      "NOBEEP"
      "AUTOCD"
      "NUMERIC_GLOB_SORT"
    ];

    profileExtra = lib.optionalString (config.home.sessionPath != []) ''
      export PATH="$PATH''${PATH:+:}${lib.concatStringsSep ":" config.home.sessionPath}"
    '';

    shellAliases = {
      # Change default
      vim = "nvim";
      vi = "nvim";
      cd = "z";
      ls = "eza --icons=always --no-quotes";
      tree = "eza --icons=always --tree --no-quotes";
      cat = "bat --theme=base16 --color=always --paging=never --tabs=2 --wrap=never --plain";
      mkdir = "mkdir -p";
      nix-shell = "nix-shell --command zsh";
      grep = "rg --color=auto";
      diff = "diff --color=auto";
      df = "df -h";

      # Shortcuts
      spt = "spotatui";
      open = "${pkgs.xdg-utils}/bin/xdg-open";

      notes = "nvim ~/notes/index.md --cmd 'cd ~/notes' -c ':lua Snacks.picker.smart()'";

      # git
      g = "lazygit";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gpl = "git pull";
      gs = "git status";
      gd = "git diff";
      gco = "git checkout";
      gcb = "git checkout -b";
      gbr = "git branch";
      grs = "git reset HEAD~1";
      grh = "git reset --hard HEAD~1";
      gaa = "git add .";
      gcm = "git commit -m";

      # Original binaries
      ocat = "/run/current-system/sw/bin/cat";
      ols = "/run/current-system/sw/bin/ls";
      ocd = "builtin cd";

      # Typo
      clera = "clear";
      celar = "clear";
      claer = "clear";
      sl = "ls";
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 550 ''
        function zvm_config() {
          ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
          ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
          ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK

          ZVM_VI_HIGHLIGHT_BACKGROUND=none
          ZVM_VI_HIGHLIGHT_FOREGROUND=none
          ZVM_VI_HIGHLIGHT_EXTRASTYLE=none
        }
      '')
      # bash
      ''
        # Suffix Aliases
        alias -s {nix,md,txt,yml,yaml,go}=nvim
        alias -s {json,jsonl}=jless
        alias -s {csv,tsv,parquet,pqt,arrow,db,sqlite,xls,xlsx,xlsm,xlsb,fwf}=tw
        alias -s {png,jpg,jpeg,gif,pdf}=xdg-open

        # Global Aliases
        alias -g G="| rg"
        alias -g L="| less"
        alias -g V="| nvim"
        alias -g H="| head"
        alias -g T="| tail"
        alias -g JQ="| jq"
        alias -g C="| wl-copy"
        alias -g NE="2>/dev/null"
        alias -g ND=">/dev/null"
        alias -g NUL=">/dev/null 2>&1"

        autoload zmv # Mv for multiple files

        zstyle ':completion:*' menu select
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

        zvm_after_init() {
          bindkey '^[[1;5C' forward-word
          bindkey '^[[1;5D' backward-word
          bindkey '^F' _fzf_file_no_hidden
          bindkey '^[[A' history-substring-search-up
          bindkey '^[[B' history-substring-search-down
        }
      ''
    ];
  };
}
