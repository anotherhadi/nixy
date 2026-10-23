# Ghostty is a terminal emulator
{
  aspects,
  config,
  ...
}: let
  inherit (config) theme;
  c = theme.colors;
in {
  flake.modules.nixos.ghostty = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({
        lib,
        pkgs,
        options,
        ...
      }: let
        cursorShaders = pkgs.fetchFromGitHub {
          owner = "sahaj-b";
          repo = "ghostty-cursor-shaders";
          rev = "06d4e90fb5410e9c4d0b3131584060adddf89406";
          hash = "sha256-G/UIr1bKnxn1AcHl/4FL/jou6b7M2VeREslYVELxdmw=";
        };
        toGhosttyConf = lib.generators.toKeyValue {
          listsAsDuplicateKeys = true;
          mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
        };
      in {
        config = lib.mkMerge [
          {
            packages = [pkgs.ghostty];

            environment.sessionVariables = {
              TERMINAL = "ghostty";
              TERM = "ghostty";
            };

            xdg.config.files."ghostty/config".text = toGhosttyConf {
              theme = "nixy";
              font-family = [theme.fonts.monospace theme.fonts.emoji];
              font-size = theme.fonts.sizes.terminal;
              background-opacity = 1.0;

              window-padding-x = 10;
              window-padding-y = 10;
              window-padding-color = "extend-always";
              confirm-close-surface = false;
              gtk-single-instance = true;
              clipboard-read = "allow";
              clipboard-write = "allow";
              copy-on-select = "clipboard";
              app-notifications = false;
              custom-shader = "${cursorShaders}/cursor_warp.glsl";
              custom-shader-animation = "always";
              mouse-scroll-multiplier = "discrete:1";
              keybind = [
                "shift+ctrl+tab=new_tab"
              ];
            };

            xdg.config.files."ghostty/themes/nixy".text = toGhosttyConf {
              background = c.base00;
              foreground = c.base05;
              cursor-color = c.base05;
              selection-background = c.base02;
              selection-foreground = c.base05;
              palette = lib.imap0 (i: base: "${toString i}=#${c.${base}}") theme.ansi;
            };

            # Single-instance daemon, started by sway (exec) or D-Bus activation
            systemd.packages = [pkgs.ghostty];
            xdg.data.files."dbus-1/services/com.mitchellh.ghostty.service".source = "${pkgs.ghostty}/share/dbus-1/services/com.mitchellh.ghostty.service";
          }

          (lib.optionalAttrs (options ? zsh) {
            zsh.initContent = lib.mkOrder 1100 ''
              if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
                source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
              fi
            '';
          })
        ];
      })
    ];
  };
}
