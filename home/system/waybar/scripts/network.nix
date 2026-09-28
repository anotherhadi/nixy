{
  pkgs,
  scripts,
  ...
}: let
  updateOsd = ''
    ${scripts.waybar-osd}/bin/waybar-osd "$OSD_TEXT"
  '';
in {
  scripts.networkScript = pkgs.writeShellScript "waybar-network" ''
    nmcli=${pkgs.networkmanager}/bin/nmcli
    ip=${pkgs.iproute2}/bin/ip
    jq=${pkgs.jq}/bin/jq
    nl=$'\n'

    text=""
    tip=""
    class="disconnected"
    add_seg() { text="''${text:+$text }$1"; }
    add_tip() { tip="''${tip:+$tip$nl}$1"; }

    # ── Ethernet ────────────────────────────────────────────────
    eth=$("$nmcli" -t -f DEVICE,TYPE,STATE device status 2>/dev/null \
      | awk -F: '$2 == "ethernet" && $3 == "connected" { print $1; exit }')
    if [ -n "$eth" ]; then
      eth_ip=$("$ip" -4 -br addr show "$eth" 2>/dev/null | awk '{ print $3 }' | cut -d/ -f1)
      add_seg "󰛳"
      class="ethernet"
      add_tip "󰛳  Ethernet''${eth_ip:+  ·  $eth_ip}"
    fi

    # ── Wi-Fi ───────────────────────────────────────────────────
    wifi=$("$nmcli" -t -f ACTIVE,SSID,SIGNAL device wifi 2>/dev/null | grep -m1 '^yes:')
    if [ -n "$wifi" ]; then
      ssid=$(printf '%s' "$wifi" | cut -d: -f2)
      signal=$(printf '%s' "$wifi" | cut -d: -f3)
      if   [ "''${signal:-0}" -ge 80 ]; then icon="󰤨"
      elif [ "''${signal:-0}" -ge 60 ]; then icon="󰤥"
      elif [ "''${signal:-0}" -ge 40 ]; then icon="󰤢"
      elif [ "''${signal:-0}" -ge 20 ]; then icon="󰤟"
      else                                    icon="󰤯"
      fi
      add_seg "$icon"
      [ "$class" = "disconnected" ] && class="wifi"
      add_tip "$icon  ''${ssid:-Wi-Fi}''${signal:+  ·  $signal%}"
    fi

    # ── VPN (nmcli, fallback interfaces) ────────────────────────
    vpn=$("$nmcli" -t -f TYPE,NAME connection show --active 2>/dev/null \
      | awk -F: '$1 == "vpn" || $1 == "wireguard" { print $2; exit }')
    if [ -z "$vpn" ]; then
      vpn=$("$ip" -br link show 2>/dev/null \
        | awk '($2 == "UP" || $2 == "UNKNOWN") && $1 ~ /^(tun|wg|proton|ppp)/ { sub(/@.*/, "", $1); print $1; exit }')
    fi
    if [ -n "$vpn" ]; then
      add_seg "󰦝"
      add_tip "󰦝  VPN  ·  $vpn"
    fi

    if [ -z "$text" ]; then
      text="󰤭"
      tip="Disconnected"
    fi

    "$jq" -cn --arg text "$text" --arg class "$class" --arg tooltip "$tip" \
      '{ text: $text, class: $class, tooltip: $tooltip }'
  '';

  scripts.wifi-toggle = pkgs.writeShellScriptBin "wifi-toggle" ''
    if ${pkgs.networkmanager}/bin/nmcli radio wifi | grep -q enabled; then
      ${pkgs.networkmanager}/bin/nmcli radio wifi off
    else
      ${pkgs.networkmanager}/bin/nmcli radio wifi on
    fi
    ${updateOsd}
  '';
}
