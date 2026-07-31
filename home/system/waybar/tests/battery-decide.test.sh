#!/usr/bin/env bash
# Unit tests for battery_decide. Run: bash home/system/waybar/tests/battery-decide.test.sh
set -u

DIR="$(cd "$(dirname "$0")/.." && pwd)"
BATTERY_MONITOR_TEST=1 . "$DIR/battery-monitor.sh"

fail=0
check() {
  desc=$1 status=$2 cap=$3 prev=$4 expected=$5
  got=$(battery_decide "$status" "$cap" "$prev")
  if [ "$got" = "$expected" ]; then
    printf 'ok   - %s\n' "$desc"
  else
    printf 'FAIL - %s: expected %s, got %s\n' "$desc" "$expected" "$got"
    fail=1
  fi
}

check "discharging 4% fresh -> crit"                Discharging 4   none   crit_show:crit5
check "discharging 4% already crit -> refresh"      Discharging 4   crit5  crit_show:crit5
check "discharging 5% boundary -> crit"             Discharging 5   none   crit_show:crit5
check "discharging 8% fresh -> warn osd"            Discharging 8   none   osd_warn:warn10
check "discharging 8% already warned -> noop"       Discharging 8   warn10 noop:warn10
check "discharging 8% recovering from crit -> clear+warn" Discharging 8 crit5 crit_clear:warn10
check "discharging 10% boundary -> warn"            Discharging 10  none   osd_warn:warn10
check "discharging 11% -> noop none"                Discharging 11  none   noop:none
check "discharging 12% rearm from warn -> none"     Discharging 12  warn10 noop:none
check "discharging 40% recover from crit -> clear"  Discharging 40  crit5  crit_clear:none
check "charging 4% from crit -> clear"              Charging    4   crit5  crit_clear:none
check "charging 8% from warn -> none"               Charging    8   warn10 noop:none
check "full 100% -> noop none"                      Full        100 none   noop:none

exit $fail
