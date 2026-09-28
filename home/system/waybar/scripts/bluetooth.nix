{
  pkgs,
  scripts,
  ...
}: let
  updateOsd = ''
    ${scripts.waybar-osd}/bin/waybar-osd "$OSD_TEXT"
  '';
in {
  scripts.bluetoothScript = pkgs.writeShellScript "waybar-bluetooth" ''
    jq=${pkgs.jq}/bin/jq
    nl=$'\n'
    # bluetoothctl hangs without a controller by default → always bounded by timeout.
    bt() { timeout 3 ${pkgs.bluez}/bin/bluetoothctl "$@" 2>/dev/null; }

    powered=$(bt show | awk '/Powered:/ { print $2; exit }')
    if [ "$powered" != "yes" ]; then
      "$jq" -cn '{ text: "󰂲", class: "off", tooltip: "Bluetooth off" }'
      exit 0
    fi

    tip=""
    add_tip() { tip="''${tip:+$tip$nl}$1"; }

    count=0
    for mac in $(bt devices Connected | awk '{ print $2 }'); do
      count=$((count + 1))
      info=$(bt info "$mac")
      name=$(printf '%s' "$info" | sed -n 's/^[[:space:]]*Name: //p' | head -1)
      [ -z "$name" ] && name="$mac"
      batt=$(printf '%s' "$info" | sed -n 's/.*Battery Percentage:.*(\([0-9][0-9]*\)).*/\1/p' | head -1)
      add_tip "󰂱  $name''${batt:+  ·  $batt%}"
    done

    if [ "$count" -gt 0 ]; then
      "$jq" -cn --arg tooltip "$tip" '{ text: "󰂰", class: "connected", tooltip: $tooltip }'
    else
      "$jq" -cn '{ text: "󰂰", class: "on", tooltip: "Bluetooth on" }'
    fi
  '';

  scripts.bluetooth-toggle = pkgs.writeShellScriptBin "bluetooth-toggle" ''
    if ${pkgs.bluez}/bin/bluetoothctl show | grep -q "Powered: yes"; then
      ${pkgs.bluez}/bin/bluetoothctl power off
    else
      ${pkgs.bluez}/bin/bluetoothctl power on
    fi
    ${updateOsd}
  '';
}
