# battery-monitor: low-battery alerts for waybar/swaync.
# Runs main once (triggered by the battery-monitor systemd timer).

POWER_SUPPLY_DIR="${POWER_SUPPLY_DIR:-/sys/class/power_supply}"
STATE_FILE="${BATTERY_STATE_FILE:-/tmp/battery-alert-state}"
CRIT_ID_FILE="${BATTERY_CRIT_ID_FILE:-/tmp/battery-crit-id}"

WARN_THRESHOLD=10
CRIT_THRESHOLD=5

# Pure decision. Prints "<action>:<newstate>".
# action ∈ noop | osd_warn | crit_show | crit_clear ; state ∈ none | warn10 | crit5
battery_decide() {
  status=$1
  cap=$2
  prev=$3

  if [ "$status" = "Discharging" ]; then
    if [ "$cap" -le "$CRIT_THRESHOLD" ]; then
      echo "crit_show:crit5"
    elif [ "$cap" -le "$WARN_THRESHOLD" ]; then
      if [ "$prev" = "crit5" ]; then
        echo "crit_clear:warn10"
      elif [ "$prev" = "warn10" ]; then
        echo "noop:warn10"
      else
        echo "osd_warn:warn10"
      fi
    else
      if [ "$prev" = "crit5" ]; then
        echo "crit_clear:none"
      else
        echo "noop:none"
      fi
    fi
  else
    if [ "$prev" = "crit5" ]; then
      echo "crit_clear:none"
    else
      echo "noop:none"
    fi
  fi
}

# First real battery (type == Battery, with status + capacity).
resolve_battery() {
  for d in "$POWER_SUPPLY_DIR"/*; do
    [ -r "$d/type" ] || continue
    [ "$(cat "$d/type")" = "Battery" ] || continue
    [ -r "$d/status" ] && [ -r "$d/capacity" ] || continue
    printf '%s' "$d"
    return 0
  done
  return 1
}

show_warn_osd() {
  waybar-osd "󰂃  Low battery · $1%"
}

show_crit_notification() {
  cap=$1
  id=$(cat "$CRIT_ID_FILE" 2>/dev/null || echo 0)
  newid=$(notify-send --print-id --replace-id="$id" \
    --urgency=critical --expire-time=0 \
    "󰂃 Critical battery" "Battery at $cap%: plug in the charger")
  printf '%s' "$newid" >"$CRIT_ID_FILE"
}

clear_crit_notification() {
  id=$(cat "$CRIT_ID_FILE" 2>/dev/null || echo 0)
  if [ "$id" != "0" ]; then
    gdbus call --session \
      --dest org.freedesktop.Notifications \
      --object-path /org/freedesktop/Notifications \
      --method org.freedesktop.Notifications.CloseNotification "$id" \
      >/dev/null 2>&1 || true
  fi
  rm -f "$CRIT_ID_FILE"
}

main() {
  dir=$(resolve_battery) || exit 0

  status=$(cat "$dir/status")
  cap=$(cat "$dir/capacity")
  prev=$(cat "$STATE_FILE" 2>/dev/null || echo none)

  result=$(battery_decide "$status" "$cap" "$prev")
  action=${result%%:*}
  newstate=${result##*:}

  case "$action" in
  osd_warn) show_warn_osd "$cap" ;;
  crit_show) show_crit_notification "$cap" ;;
  crit_clear) clear_crit_notification ;;
  noop) : ;;
  esac

  printf '%s' "$newstate" >"$STATE_FILE"
}

main "$@"
