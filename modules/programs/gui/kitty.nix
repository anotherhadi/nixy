# Kitty is a terminal emulator
{
  aspects,
  config,
  ...
}: let
  inherit (config) theme;
  c = theme.colors;
in {
  flake.modules.nixos.kitty = {pkgs, ...}: {
    imports = [aspects.hjem];

    environment.systemPackages = [pkgs.kitty.terminfo];

    hjem.extraModules = [
      ({
        lib,
        options,
        ...
      }: let
        toKittyConf = lib.generators.toKeyValue {
          listsAsDuplicateKeys = true;
          mkKeyValue = lib.generators.mkKeyValueDefault {} " ";
        };
      in {
        config = lib.mkMerge [
          {
            packages = [pkgs.kitty];

            scripts.term = pkgs.writeShellScriptBin "term" ''
              exec ${pkgs.kitty}/bin/kitty -1 "$@"
            '';

            environment.sessionVariables.TERMINAL = "kitty";

            xdg.config.files."kitty/kitty.conf".text =
              toKittyConf {
                font_family = theme.fonts.monospace;
                font_size = theme.fonts.sizes.terminal;
                background_opacity = "1.0";

                window_padding_width = 10;
                confirm_os_window_close = 0;
                clipboard_control = "write-clipboard write-primary read-clipboard read-primary";
                copy_on_select = "clipboard";
                wheel_scroll_multiplier = "1.0";
                cursor_trail = 3;
                cursor_trail_decay = "0.1 0.3";
                shell_integration = "no-rc"; # Sourced from .zshrc below
                update_check_interval = 0;
                enable_audio_bell = "no";
                map = [
                  "ctrl+shift+tab new_tab_with_cwd"
                  "ctrl+shift+t new_tab_with_cwd"
                ];

                tab_bar_edge = "top";
                tab_bar_style = "powerline";
                tab_powerline_style = "round";
                tab_title_template = "{index}: {title}";
                active_tab_font_style = "bold";
                inactive_tab_font_style = "normal";

                background = "#${c.base00}";
                foreground = "#${c.base05}";
                cursor = "#${c.base05}";
                selection_background = "#${c.base02}";
                selection_foreground = "#${c.base05}";
                tab_bar_background = "#${c.base01}";
                active_tab_background = "#${c.base0D}";
                active_tab_foreground = "#${c.base00}";
                inactive_tab_background = "#${c.base02}";
                inactive_tab_foreground = "#${c.base04}";
              }
              + toKittyConf (lib.listToAttrs (lib.imap0 (i: base: {
                  name = "color${toString i}";
                  value = "#${c.${base}}";
                })
                theme.ansi));

            # Single-instance server, windows open in it with `term`
            systemd.services.kitty = {
              description = "kitty terminal server";
              after = ["graphical-session.target"];
              partOf = ["graphical-session.target"];
              wantedBy = ["graphical-session.target"];
              serviceConfig = {
                ExecStart = "${pkgs.kitty}/bin/kitty -1 --start-as=hidden";
                Restart = "on-failure";
              };
            };
          }

          (lib.optionalAttrs (options ? zsh) {
            zsh.initContent = lib.mkOrder 1100 ''
              if [[ -n $KITTY_INSTALLATION_DIR ]]; then
                export KITTY_SHELL_INTEGRATION="enabled"
                autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
                kitty-integration
                unfunction kitty-integration
              fi
            '';
          })
        ];
      })
    ];
  };
}
