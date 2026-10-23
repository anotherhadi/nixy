# Hyprlock: lock screen drawn like a terminal running `sudo` in tmux
{config, ...}: let
  inherit (config) theme;
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

        label = {
          text,
          position,
          color ? c.base05,
          halign ? "left",
          valign ? "bottom",
        }: ''
          label {
            monitor =
            color = rgb(${color})
            font_family = ${font}
            font_size = ${toString fontSize}
            halign = ${halign}
            position = ${position}
            text = ${text}
            valign = ${valign}
          }
        '';
      in {
        scripts.lock = pkgs.writeShellScriptBin "lock" ''
          ${pkgs.procps}/bin/pidof ${pkgs.hyprlock}/bin/hyprlock || exec ${pkgs.hyprlock}/bin/hyprlock "$@"
        '';

        launcher.lock.name = "Lock";

        xdg.config.files."hypr/hyprlock.conf".text = ''
          background {
            monitor =
            color = rgba(${c.base00}FF)
          }

          input-field {
            monitor =
            size = ${px (40 * charW)}, ${px inputH}
            capslock_color = rgb(${c.base0A})
            check_color = rgb(${c.base0C})
            dots_center = false
            dots_size = 0.8
            dots_spacing = 0.0
            dots_text_format = *
            fade_on_empty = false
            fail_color = rgb(${c.base08})
            fail_text = <span> </span>
            font_color = rgb(${c.base05})
            font_family = ${font}
            halign = left
            inner_color = rgba(00000000)
            outer_color = rgba(00000000)
            outline_thickness = 0
            placeholder_text = <span> </span>
            position = ${px (margin + builtins.stringLength prompt * charW - dotPad)}, ${px (-margin - lineH + dotPad)}
            rounding = 0
            swap_font_color = true
            valign = top
          }

          ${label {
            text = "[lock] 0:sudo*";
            color = c.base04;
            position = "${px margin}, 0";
          }}
          ${label {
            text = "cmd[update:5000] ${scripts.status-pills}";
            position = "${px (-margin)}, 0";
            halign = "right";
          }}
          ${label {
            text = "cmd[update:0] ${lastLine} $ATTEMPTS";
            position = "${px margin}, ${px (-margin)}";
            valign = "top";
          }}
          ${label {
            text = prompt;
            position = "${px margin}, ${px (-margin - lineH)}";
            valign = "top";
          }}
          shape {
            monitor =
            size = 100%, ${px barH}
            border_size = 0
            color = rgb(${c.base01})
            halign = left
            position = 0, 0
            rounding = 0
            valign = bottom
          }
        '';
      })
    ];
  };
}
