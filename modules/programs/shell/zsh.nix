# My shell configuration
{aspects, ...}: {
  flake.modules.nixos.shell = {
    imports = [aspects.hjem];

    programs.zsh.enable = true;
    # Zsh completions of system packages (systemd, ...)
    environment.pathsToLink = ["/share/zsh"];

    hjem.extraModules = [
      ({
        config,
        lib,
        pkgs,
        osConfig,
        ...
      }: let
        cfg = config.zsh;
        impermanence = osConfig.environment.persistence."/persist".enable;
        historyFile =
          if impermanence
          then "/persist${config.directory}/.zsh_history"
          else "${config.directory}/.zsh_history";
      in {
        options.zsh = {
          shellAliases = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            default = {};
          };
          initContent = lib.mkOption {
            type = lib.types.lines;
            default = "";
          };
        };

        config = {
          packages = with pkgs; [
            bat
            ripgrep
            nix-zsh-completions
          ];

          environment.sessionVariables = {
            COLORTERM = "truecolor";
            MANPAGER = "bat -l man -p";
          };

          files.".zshenv".text = ''
            # Environment variables (hjem environment.sessionVariables)
            if [[ -z "''${__HJEM_SESS_VARS_SOURCED-}" ]]; then
              export __HJEM_SESS_VARS_SOURCED=1
              . ${config.environment.loadEnv}
            fi
          '';

          files.".zshrc".text = cfg.initContent;

          zsh.shellAliases = {
            # Change default
            vim = "nvim";
            vi = "nvim";
            mkdir = "mkdir -p";
            nix-shell = "nix-shell --command zsh";
            diff = "diff --color=auto";
            df = "df -h";

            # Shortcuts
            open = "${pkgs.xdg-utils}/bin/xdg-open";
            cyber = "cd ~/Cyber && nvim .";
            notes = "cd ~/Notes && nvim .";

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

          zsh.initContent = lib.mkMerge [
            (lib.mkOrder 100 ''
              typeset -U path cdpath fpath manpath
              for profile in ''${(z)NIX_PROFILES}; do
                fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
              done

              HELPDIR="${pkgs.zsh}/share/zsh/$ZSH_VERSION/help"
            '')

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

            (lib.mkOrder 570 ''
              autoload -U compinit && compinit
              source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
              ZSH_AUTOSUGGEST_STRATEGY=(history)

              source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
            '')

            (lib.mkOrder 600 ''
              HISTSIZE="10000"
              SAVEHIST="10000"

              HISTFILE="${historyFile}"
              mkdir -p "$(dirname "$HISTFILE")"

              setopt NOBEEP AUTOCD NUMERIC_GLOB_SORT HIST_FCNTL_LOCK APPEND_HISTORY \
                HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS HIST_IGNORE_DUPS HIST_IGNORE_SPACE \
                SHARE_HISTORY NO_EXTENDED_HISTORY NO_HIST_IGNORE_ALL_DUPS NO_HIST_SAVE_NO_DUPS
            '')

            # bash
            ''
              # cat: preview images inline instead of dumping bat's binary garbage
              cat() {
                local -a imgs rest
                local f
                for f in "$@"; do
                  case "''${f:l}" in
                    *.png|*.jpg|*.jpeg|*.gif|*.bmp|*.webp|*.tiff|*.ico)
                      imgs+=("$f")
                      ;;
                    *)
                      rest+=("$f")
                      ;;
                  esac
                done

                if (( ''${#imgs} )); then
                  for f in "''${imgs[@]}"; do
                    chafa --format=kitty "$f"
                  done
                fi

                if (( ''${#rest} || ! ''${#imgs} )); then
                  bat --theme=base16 --color=auto --paging=never --tabs=2 --wrap=never --plain "''${rest[@]}"
                fi
              }

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
              alias -g NO='; ${pkgs.libnotify}/bin/notify-send "$? · ''${history[$HISTCMD]% NO}"'
              alias -g NS='; signal-notify "$HOST: $? · ''${history[$HISTCMD]% NS}"'
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
                bindkey '^R' fzf-history-widget
                bindkey '^[[A' history-substring-search-up
                bindkey '^[[B' history-substring-search-down
              }
            ''

            (lib.mkOrder 1200 (lib.concatStringsSep "\n" (
              lib.mapAttrsToList (k: v: "alias -- ${k}=${lib.escapeShellArg v}") cfg.shellAliases
            )))

            (lib.mkOrder 1300 ''
              source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
              ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)

              source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
              bindkey "^[[A" history-substring-search-up
              bindkey "^[[B" history-substring-search-down
            '')
          ];
        };
      })
    ];
  };
}
