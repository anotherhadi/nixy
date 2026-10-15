# starship is a minimal, fast, and extremely customizable prompt for any shell!
{config, ...}: let
  c = config.theme.withHashtag;
  accent = c.base0D;
  background-alt = c.base01;
in {
  flake.modules.nixos.shell = {
    hjem.extraModules = [
      ({
        lib,
        pkgs,
        ...
      }: {
        packages = [pkgs.starship];

        xdg.config.files."starship.toml" = {
          generator = (pkgs.formats.toml {}).generate "starship.toml";
          value = {
            add_newline = true;
            format = lib.concatStrings [
              "$nix_shell"
              "$hostname"
              "$directory"
              "$git_branch"
              "$git_state"
              "$git_status"
              "$character"
            ];
            directory = {
              style = accent;
            };

            character = {
              success_symbol = "[❯](${accent})";
              error_symbol = "[❯](red)";
              vimcmd_symbol = "[❮](cyan)";
            };

            nix_shell = {
              format = "[$symbol]($style) ";
              symbol = "🐚";
              style = "";
            };

            git_branch = {
              symbol = "[](${background-alt}) ";
              style = "fg:${accent} bg:${background-alt}";
              format = "on [$symbol$branch]($style)[](${background-alt}) ";
            };

            git_status = {
              format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218)($ahead_behind$stashed)]($style)";
              style = "cyan";
              conflicted = "";
              renamed = "";
              deleted = "";
              stashed = "≡";
            };

            git_state = {
              format = "([$state( $progress_current/$progress_total)]($style)) ";
              style = "bright-black";
            };

            # Named colors (red, cyan, bright-black...) follow the theme
            palette = "base16";
            palettes.base16 =
              c
              // {
                black = c.base00;
                white = c.base05;
                bright-black = c.base03;
                bright-white = c.base07;
                red = c.base08;
                bright-red = c.base08;
                orange = c.base09;
                yellow = c.base0A;
                bright-yellow = c.base0A;
                green = c.base0B;
                bright-green = c.base0B;
                cyan = c.base0C;
                bright-cyan = c.base0C;
                blue = c.base0D;
                bright-blue = c.base0D;
                magenta = c.base0E;
                bright-magenta = c.base0E;
                purple = c.base0E;
                bright-purple = c.base0E;
                brown = c.base0F;
              };
          };
        };

        zsh.initContent = lib.mkOrder 1100 ''
          if [[ $TERM != "dumb" ]]; then
            eval "$(${pkgs.starship}/bin/starship init zsh)"
          fi
        '';
      })
    ];
  };
}
