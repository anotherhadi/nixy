{ pkgs, ... }: {
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

      bind-key -n C-Tab select-window -n
      bind-key -n C-S-Tab previous-window

      bind-key "t" run-shell "sesh connect \"$(
        sesh list -t | fzf-tmux -p 65%,70% \
          --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
          --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list)' \
          --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t)' \
          --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c)' \
          --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z)' \
          --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
          --bind 'ctrl-d:execute(tmux kill-session -t {})+change-prompt(⚡  )+reload(sesh list)'
      )\""
    '';

    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set-option -g status-position top
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"

          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"

          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W"

          set -g @catppuccin_status_modules_right ""
          set -g @catppuccin_status_left_separator  " "
          set -g @catppuccin_status_right_separator ""
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"

          set -g @catppuccin_directory_text "#{pane_current_path}"
          set -g @catppuccin_status_background "default"
          set-option -g default-terminal "screen-256color"
        '';
      }
    ];
  };
}
