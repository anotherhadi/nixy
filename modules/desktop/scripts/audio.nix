{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      pkgs,
      scripts,
      ...
    }: let
      volGetText = ''
        VOL_RAW=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_SINK@)
        VOL=$(printf '%s' "$VOL_RAW" | awk '{printf "%d", $2*100}')
        if printf '%s' "$VOL_RAW" | grep -q MUTED; then
          OSD_TEXT="󰝟  $VOL%"
        elif [ "$VOL" -lt 33 ]; then
          OSD_TEXT="󰕿  $VOL%"
        elif [ "$VOL" -lt 66 ]; then
          OSD_TEXT="󰖀  $VOL%"
        else
          OSD_TEXT="󰕾  $VOL%"
        fi
      '';

      micSource = ''
        src=$(${pkgs.wireplumber}/bin/wpctl inspect @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | sed -n 's/^id \([0-9]*\),.*/\1/p')
        if [ -z "$src" ]; then
          src=$(${pkgs.pipewire}/bin/pw-dump | ${pkgs.jq}/bin/jq -r \
            '[.[] | select(.info.props."media.class"=="Audio/Source") | .id] | .[0] // empty')
        fi
      '';

      updateOsd = ''
        ${scripts.osd}/bin/osd "$OSD_TEXT" audio
      '';

      cycleDefault = class: default: icon: fallback: ''
        wpctl=${pkgs.wireplumber}/bin/wpctl
        jq=${pkgs.jq}/bin/jq
        pwdump=${pkgs.pipewire}/bin/pw-dump

        # Node IDs in pw-dump order.
        ids=($("$pwdump" | "$jq" -r '.[] | select(.info.props."media.class"=="${class}") | .id'))
        n=''${#ids[@]}
        [ "$n" -eq 0 ] && exit 0

        cur=$("$wpctl" inspect ${default} 2>/dev/null | sed -n 's/^id \([0-9]*\),.*/\1/p')

        next_index=0
        for i in "''${!ids[@]}"; do
          if [ "''${ids[$i]}" = "$cur" ]; then
            next_index=$(( (i + 1) % n ))
            break
          fi
        done
        next=''${ids[$next_index]}

        "$wpctl" set-default "$next"
        desc=$("$pwdump" | "$jq" -r --argjson id "$next" '.[] | select(.id==$id) | .info.props."node.description"')
        OSD_TEXT="${icon}  ''${desc:-${fallback}}"
        ${updateOsd}
      '';
    in {
      scripts.vol-up = pkgs.writeShellScriptBin "vol-up" ''
        ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%+ --limit 1.0
        ${volGetText}
        ${updateOsd}
      '';

      scripts.vol-down = pkgs.writeShellScriptBin "vol-down" ''
        ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%-
        ${volGetText}
        ${updateOsd}
      '';

      scripts.vol-mute = pkgs.writeShellScriptBin "vol-mute" ''
        ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle
        ${volGetText}
        ${updateOsd}
      '';

      scripts.mic-mute = pkgs.writeShellScriptBin "mic-mute" ''
        wpctl=${pkgs.wireplumber}/bin/wpctl
        ${micSource}
        [ -z "$src" ] && exit 0

        "$wpctl" set-mute "$src" toggle
        if "$wpctl" get-volume "$src" | grep -q MUTED; then
          OSD_TEXT="󰍭  Muted"
        else
          OSD_TEXT="󰍬  Live"
        fi
        ${updateOsd}
      '';

      scripts.mic-status = pkgs.writeShellScriptBin "mic-status" ''
        ${micSource}
        if [ -n "$src" ] && ${pkgs.wireplumber}/bin/wpctl get-volume "$src" | grep -q MUTED; then
          echo true
        else
          echo false
        fi
      '';

      scripts.audio-output-cycle =
        pkgs.writeShellScriptBin "audio-output-cycle"
        (cycleDefault "Audio/Sink" "@DEFAULT_AUDIO_SINK@" "󰓃" "Output");

      scripts.audio-input-cycle =
        pkgs.writeShellScriptBin "audio-input-cycle"
        (cycleDefault "Audio/Source" "@DEFAULT_AUDIO_SOURCE@" "󰍬" "Input");

      launcher.vol-up.name = "Volume Up";
      launcher.vol-down.name = "Volume Down";
      launcher.vol-mute.name = "Mute Volume";
      launcher.mic-mute.name = "Mute Microphone";
      launcher.audio-output-cycle.name = "Cycle Audio Output";
      launcher.audio-input-cycle.name = "Cycle Audio Input";

      packages = with pkgs; [playerctl pavucontrol];
    })
  ];
}
