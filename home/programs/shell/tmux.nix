# Tmux is a terminal multiplexer that allows you to run multiple terminal sessions in a single window.
{ pkgs, ... }:
let
  Config = pkgs.writeShellScriptBin "Config" ''
    SESSION="Nixy Config"

    tmux has-session -t "$SESSION" 2>/dev/null

    if [ $? == 0 ]; then
      tmux attach -t "$SESSION"
      exit 0
    fi

    tmux new-session -d -s "$SESSION"
    tmux send-keys -t "$SESSION" "sleep 0.2 && clear && cd ~/.config/nixos/ && vim" C-m

    tmux new-window -t "$SESSION" -n "nixy"
    tmux send-keys -t "$SESSION":1 "sleep 0.2 && clear && cd ~/.config/nixos/ && nixy loop" C-m

    tmux new-window -t "$SESSION" -n "lazygit"
    tmux send-keys -t "$SESSION":2 "sleep 0.2 && clear && cd ~/.config/nixos/ && lazygit" C-m

    tmux select-window -t "$SESSION":0
    tmux select-pane -t 0
    tmux attach -t "$SESSION"
  '';
in {
  programs.tmux = {
    enable = true;
    mouse = true;
    shell = "${pkgs.zsh}/bin/zsh";
    prefix = "C-s";
    terminal = "kitty";
    keyMode = "vi";

    extraConfig = ''
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      set -gq allow-passthrough on
      bind-key x kill-pane # skip "kill-pane 1? (y/n)" prompt

      bind-key -n C-Tab next-window
      bind-key -n C-S-Tab previous-window
      bind-key -n M-Tab new-window
    '';

    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      # tmuxPlugins.resurrect
      tmuxPlugins.sensible
      tmuxPlugins.tokyo-night-tmux
    ];
  };
  home.packages = [ Config ];
}
