# Hyprlock: lock screen drawn like a terminal running `sudo` in tmux
{config, ...}: let
  inherit (config) theme;
  inherit (config.flake.lib) toHyprconf;
  c = theme.colors;
  font = theme.fonts.monospace;
in {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    environment.systemPackages = [pkgs.hyprlock];
    security.pam.services.hyprlock = {};

    hjem.extraModules = [
      ({
        config,
        pkgs,
        osConfig,
        scripts,
        ...
      }: let
        fontSize = 16;
        em = fontSize * 4.0 / 3.0;
        charW = em * 0.6;
        lineH = em * 1.32;

        round = x: builtins.floor (x + 0.5);
        px = x: toString (round x);

        paint = color: t: ''<span foreground="#${color}">${t}</span>'';

        user = config.user;
        host = osConfig.networking.hostName;

        margin = 2 * charW;
        barH = lineH;
        prompt = "[sudo] password for ${user}: ";

        inputH = fontSize / 0.8;
        dotPad = (inputH - lineH) / 2.0;

        lastLine = pkgs.writeShellScript "hyprlock-last-line" ''
          n=''${1:-0}
          if [ "$n" -eq 0 ]; then
            printf '%s' '${paint c.base0B "${user}@${host}"}:${paint c.base0D "~"}$ unlock'
          elif [ "$n" -eq 1 ]; then
            printf 'sudo: 1 incorrect password attempt'
          else
            printf 'sudo: %s incorrect password attempts' "$n"
          fi
        '';

        label = attrs:
          {
            monitor = "";
            font_size = fontSize;
            font_family = font;
            color = "rgb(${c.base05})";
            halign = "left";
            valign = "bottom";
          }
          // attrs;
      in {
        scripts.lock = pkgs.writeShellScriptBin "lock" ''
          ${pkgs.procps}/bin/pidof ${pkgs.hyprlock}/bin/hyprlock || exec ${pkgs.hyprlock}/bin/hyprlock "$@"
        '';

        launcher.lock.name = "Lock";

        xdg.config.files."hypr/hyprlock.conf".text = toHyprconf {
          importantPrefixes = ["$" "bezier" "monitor" "size"];
          attrs = {
            background = [
              {
                monitor = "";
                color = "rgba(${c.base00}FF)";
              }
            ];

            shape = [
              {
                monitor = "";
                size = "100%, ${px barH}";
                color = "rgb(${c.base01})";
                rounding = 0;
                border_size = 0;
                position = "0, 0";
                halign = "left";
                valign = "bottom";
              }
            ];

            label = [
              (label {
                text = "[lock] 0:sudo*";
                color = "rgb(${c.base04})";
                position = "${px margin}, 0";
              })
              (label {
                text = "cmd[update:5000] ${scripts.status-pills}";
                position = "${px (-margin)}, 0";
                halign = "right";
              })
              (label {
                text = "cmd[update:0] ${lastLine} $ATTEMPTS";
                position = "${px margin}, ${px (-margin)}";
                valign = "top";
              })
              (label {
                text = prompt;
                position = "${px margin}, ${px (-margin - lineH)}";
                valign = "top";
              })
            ];

            "input-field" = [
              {
                monitor = "";
                size = "${px (40 * charW)}, ${px inputH}";
                position = "${px (margin + builtins.stringLength prompt * charW - dotPad)}, ${px (-margin - lineH + dotPad)}";
                halign = "left";
                valign = "top";

                outline_thickness = 0;
                outer_color = "rgba(00000000)";
                inner_color = "rgba(00000000)";
                rounding = 0;
                fade_on_empty = false;

                font_family = font;
                font_color = "rgb(${c.base05})";

                dots_text_format = "*";
                dots_size = 0.8;
                dots_spacing = 0.0;
                dots_center = false;

                swap_font_color = true;
                placeholder_text = "<span> </span>";
                fail_text = "<span> </span>";
                check_color = "rgb(${c.base0C})";
                fail_color = "rgb(${c.base08})";
                capslock_color = "rgb(${c.base0A})";
              }
            ];
          };
        };
      })
    ];
  };
}
