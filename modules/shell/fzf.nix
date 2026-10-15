# Fzf is a general-purpose command-line fuzzy finder.
{config, ...}: let
  c = config.theme.withHashtag;
in {
  flake.modules.nixos.shell = {
    hjem.extraModules = [
      ({
        lib,
        pkgs,
        ...
      }: let
        previewCmd = "bat --color=always --style=plain,numbers --line-range=:500 {}";
        colors = {
          "fg+" = c.base0D;
          "bg+" = "-1";
          "fg" = c.base05;
          "bg" = "-1";
          "prompt" = c.base03;
          "pointer" = c.base0D;
          "border" = c.base03;
          "preview-border" = c.base03;
          "scrollbar" = c.base03;
          "preview-scrollbar" = c.base03;
          "gutter" = c.base03;
        };
        options = [
          "--height=60%"
          "--layout=reverse"
          "--border=none"
          "--prompt='/ '"
          "--preview-window=right:65%:wrap:border-left"
          "-i"
          "--no-bold"
          "--color ${lib.concatStringsSep "," (lib.mapAttrsToList (n: v: "${n}:${v}") colors)}"
        ];
      in {
        packages = [pkgs.fzf];

        environment.sessionVariables = {
          FZF_DEFAULT_COMMAND = "fd --type f --hidden --strip-cwd-prefix";
          FZF_CTRL_T_COMMAND = "fd --type f --hidden --strip-cwd-prefix";
          FZF_CTRL_T_OPTS = "--preview '${previewCmd}'";
          FZF_DEFAULT_OPTS = lib.concatStringsSep " " options;
        };

        zsh.initContent = lib.mkMerge [
          (lib.mkOrder 1100 ''
            if [[ $options[zle] = on ]]; then
              source <(${pkgs.fzf}/bin/fzf --zsh)
            fi
          '')
          (lib.mkAfter ''
            _fzf_file_no_hidden() {
              local cmd result
              cmd="''${FZF_DEFAULT_COMMAND/--hidden /}"
              result=$(eval "''${cmd:-find . -type f}" | fzf --preview "${previewCmd}") \
                && LBUFFER+="$result"
              zle reset-prompt
            }
            zle -N _fzf_file_no_hidden
          '')
        ];
      })
    ];
  };
}
