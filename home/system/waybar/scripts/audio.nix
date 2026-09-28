{
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

  # Resolve $src: the default source, otherwise the first available source.
  # Some machines have no default audio source (@DEFAULT_AUDIO_SOURCE@ unresolved).
  micSource = ''
    src=$(${pkgs.wireplumber}/bin/wpctl inspect @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | sed -n 's/^id \([0-9]*\),.*/\1/p')
    if [ -z "$src" ]; then
      src=$(${pkgs.pipewire}/bin/pw-dump | ${pkgs.jq}/bin/jq -r \
        '[.[] | select(.info.props."media.class"=="Audio/Source") | .id] | .[0] // empty')
    fi
  '';

  updateOsd = ''
    ${scripts.waybar-osd}/bin/waybar-osd "$OSD_TEXT"
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
}
