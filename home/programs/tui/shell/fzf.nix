# Fzf is a general-purpose command-line fuzzy finder.
{
  config,
  lib,
  ...
}: let
  accent = "#" + config.lib.stylix.colors.base0D;
  foreground = "#" + config.lib.stylix.colors.base05;
  muted = "#" + config.lib.stylix.colors.base03;
  previewCmd = "bat --color=always --style=plain,numbers --line-range=:500 {}";
in {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    defaultCommand = "fd --type f --hidden --strip-cwd-prefix";
    fileWidgetCommand = "fd --type f --hidden --strip-cwd-prefix";
    fileWidgetOptions = ["--preview '${previewCmd}'"];

    colors = lib.mkForce {
      "fg+" = accent;
      "bg+" = "-1";
      "fg" = foreground;
      "bg" = "-1";
      "prompt" = muted;
      "pointer" = accent;
    };

    defaultOptions = [
      "--height=60%"
      "--layout=reverse"
      "--border=none"
      "--prompt='/ '"
      "--preview-window=right:65%:wrap:border-left"
      "-i"
      "--no-bold"
    ];
  };

  programs.zsh.initContent = lib.mkAfter ''
    _fzf_file_no_hidden() {
      local cmd result
      cmd="''${FZF_DEFAULT_COMMAND/--hidden /}"
      result=$(eval "''${cmd:-find . -type f}" | fzf --preview "${previewCmd}") \
        && LBUFFER+="$result"
      zle reset-prompt
    }
    zle -N _fzf_file_no_hidden
  '';
}
