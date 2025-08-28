{
  config,
  pkgs,
  ...
}: let
  accent = "#${config.lib.stylix.colors.base0D}";
  background = "#${config.lib.stylix.colors.base00}";
  foreground = "#${config.lib.stylix.colors.base05}";
  borderSize = config.theme.border-size;
  nerdFont = config.stylix.fonts.sansSerif.name;

  theme = pkgs.writeTextFile {
    name = "swayosd-css";
    text = ''
      window#osd {
        padding: 12px 18px;
        border-radius: 999px;
        border: solid ${toString borderSize}px ${accent};
        background: alpha(${background}, 0.99);
      }

      #container {
        margin: 0px;
      }

      image {
        font-family: "${nerdFont}";
        font-size: 14px;
        color: ${foreground};
      }

      label {
        color: ${foreground};
      }

      progressbar:disabled,
      image:disabled {
        opacity: 0.5;
      }

      progressbar {
        min-width: 150px;
        min-height: 5px;
        border-radius: 999px;
        background: transparent;
        border: none;
      }

      trough {
        min-height: inherit;
        border-radius: inherit;
        border: none;
        background: alpha(${accent},0.3);
      }

      progress {
        min-height: inherit;
        border-radius: inherit;
        border: none;
        background: ${accent};
      }
    '';
  };
in {
  wayland.windowManager.hyprland.settings = {
    exec-once = ["swayosd-server"];
    bind = [",XF86AudioMute, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle"];
    bindl = [
      ",XF86MonBrightnessUp, exec, ${pkgs.swayosd}/bin/swayosd-client --brightness raise 5%+"
      ",XF86MonBrightnessDown, exec, ${pkgs.swayosd}/bin/swayosd-client --brightness lower 5%-"
      "$mod,F2,exec, ${pkgs.swayosd}/bin/swayosd-client --brightness 100"
      "$mod,F3,exec, ${pkgs.swayosd}/bin/swayosd-client --brightness 0"
      ",XF86AudioPlay, exec, ${pkgs.swayosd}/bin/swayosd-client --playerctl play-pause"
      ",XF86AudioNext, exec, ${pkgs.swayosd}/bin/swayosd-client --playerctl next"
      ",XF86AudioPrev, exec, ${pkgs.swayosd}/bin/swayosd-client --playerctl previous"
    ];
    bindle = [
      ",XF86AudioRaiseVolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume +2 --max-volume=100"
      ",XF86AudioLowerVolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume -2"
    ];
    bindr = [
      "CAPS,Caps_Lock,exec,${pkgs.swayosd}/bin/swayosd-client --caps-lock"
      ",Scroll_Lock,exec,${pkgs.swayosd}/bin/swayosd-client --scroll-lock"
      ",Num_Lock,exec,${pkgs.swayosd}/bin/swayosd-client --num-lock"
    ];
  };

  services.swayosd = {
    enable = true;
    stylePath = theme;
  };
}
