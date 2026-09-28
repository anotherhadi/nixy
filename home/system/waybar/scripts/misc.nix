{
  pkgs,
  scripts,
  ...
}: let
  updateOsd = ''
    ${scripts.waybar-osd}/bin/waybar-osd "$OSD_TEXT"
  '';
in {
  scripts.waybar-toggle = pkgs.writeShellScriptBin "waybar-toggle" ''
    if pidof waybar > /dev/null; then
      pkill waybar
    else
      hyprctl dispatch exec waybar
    fi
  '';

  scripts.color-pick = pkgs.writeShellScriptBin "color-pick" ''
    # hyprpicker -a already copies the color to the clipboard.
    color=$(${pkgs.hyprpicker}/bin/hyprpicker -a 2>/dev/null)
    if [ -n "$color" ]; then
      OSD_TEXT="󰈊  $color"
    else
      OSD_TEXT="󰈊  Cancelled"
    fi
    ${updateOsd}
  '';

  scripts.screenshot-edit = pkgs.writeShellScriptBin "screenshot-edit" ''
    ${pkgs.hyprshot}/bin/hyprshot -m region --raw 2>/dev/null \
      | ${pkgs.satty}/bin/satty --filename -
  '';

  scripts.record-toggle = pkgs.writeShellScriptBin "record-toggle" ''
    if pgrep -x wf-recorder >/dev/null; then
      # -INT lets wf-recorder finalize the file cleanly.
      pkill -INT -x wf-recorder
      OSD_TEXT="󰕧  Recording saved"
    else
      dir="$HOME/Videos"
      mkdir -p "$dir"
      file="$dir/rec-$(date +%Y%m%d-%H%M%S).mp4"
      ${pkgs.wf-recorder}/bin/wf-recorder -f "$file" >/dev/null 2>&1 &
      OSD_TEXT="󰑊  Recording…"
    fi
    ${updateOsd}
  '';

  scripts.airplane-toggle = pkgs.writeShellScriptBin "airplane-toggle" ''
    # Reuse nmcli + bluetoothctl (unprivileged) instead of rfkill.
    on=false
    nmcli radio wifi 2>/dev/null | grep -q enabled && on=true
    bluetoothctl show 2>/dev/null | grep -q "Powered: yes" && on=true
    if $on; then
      nmcli radio wifi off 2>/dev/null
      bluetoothctl power off >/dev/null 2>&1 || true
      OSD_TEXT="󰀝  Airplane On"
    else
      nmcli radio wifi on 2>/dev/null
      bluetoothctl power on >/dev/null 2>&1 || true
      OSD_TEXT="󰀞  Airplane Off"
    fi
    ${updateOsd}
  '';
}
