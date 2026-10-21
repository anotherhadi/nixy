# Small terminal tools without configuration
{aspects, ...}: {
  flake.modules.nixos.cli-tools = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({
        lib,
        pkgs,
        options,
        ...
      }: {
        config = lib.mkMerge [
          {
            packages = with pkgs; [
              # I love TUIs
              caligula # User-friendly, lightweight TUI for disk imaging (ISO, USB BOOT)
              sttr # A minimalist CyberChef-like, cross-platform CLI app for performing various operations on strings
              slides # A terminal-based presentation tool that allows you to create and deliver presentations directly from the command line
              tabiew # A terminal-based CSV viewer and manipulator
              jless # A pager for JSON
              dua # Tool to conveniently learn about the disk usage of directories
              lazyjournal
              vhs # Create GIF from the command-line
              pkgs.nur.repos.anotherhadi.settuings # Terminal based settings (wifi, bluetooth, audio, ...)
              pkgs.nur.repos.anotherhadi.fztea # Flipper Zero from the terminal
              pkgs.unstable.pomo # Pomodoro timer in your terminal

              httpie # Command-line HTTP client, a user-friendly cURL replacement
              figlet # Transform text into ASCII art
              pastel # Command-line tool to generate, analyze, convert and manipulate colors

              # Just cool
              tty-solitaire
              bastet
              peaclock
              cbonsai
              pipes
              cmatrix
              fastfetch
              smassh # typing test, 10fastfinger like
              cava # Audio visualizer
            ];
          }

          (lib.optionalAttrs (options ? zsh) {
            zsh.initContent = lib.mkOrder 1100 ''
              if [[ $options[zle] = on ]]; then
                eval "$(${pkgs.nur.repos.sectui.cheatmd}/bin/cheatmd widget zsh)"
              fi
            '';
          })
        ];
      })
    ];
  };
}
