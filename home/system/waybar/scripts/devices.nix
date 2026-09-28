{
  pkgs,
  scripts,
  ...
}: let
  updateOsd = ''
    ${scripts.waybar-osd}/bin/waybar-osd "$OSD_TEXT"
  '';
in {
  scripts.output-cycle = pkgs.writeShellScriptBin "output-cycle" ''
    wpctl=${pkgs.wireplumber}/bin/wpctl
    jq=${pkgs.jq}/bin/jq
    pwdump=${pkgs.pipewire}/bin/pw-dump

    # Sink IDs in pw-dump order.
    ids=($("$pwdump" | "$jq" -r '.[] | select(.info.props."media.class"=="Audio/Sink") | .id'))
    n=''${#ids[@]}
    [ "$n" -eq 0 ] && exit 0

    cur=$("$wpctl" inspect @DEFAULT_AUDIO_SINK@ 2>/dev/null | sed -n 's/^id \([0-9]*\),.*/\1/p')

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
    OSD_TEXT="󰓃  ''${desc:-Output}"
    ${updateOsd}
  '';

  scripts.input-cycle = pkgs.writeShellScriptBin "input-cycle" ''
    wpctl=${pkgs.wireplumber}/bin/wpctl
    jq=${pkgs.jq}/bin/jq
    pwdump=${pkgs.pipewire}/bin/pw-dump

    # Source IDs in pw-dump order.
    ids=($("$pwdump" | "$jq" -r '.[] | select(.info.props."media.class"=="Audio/Source") | .id'))
    n=''${#ids[@]}
    [ "$n" -eq 0 ] && exit 0

    cur=$("$wpctl" inspect @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | sed -n 's/^id \([0-9]*\),.*/\1/p')

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
    OSD_TEXT="󰍬  ''${desc:-Input}"
    ${updateOsd}
  '';
}
