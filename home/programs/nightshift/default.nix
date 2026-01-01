{pkgs, ...}: let
  nightshift-toggle =
    pkgs.writeShellScriptBin "nightshift-toggle"
    # bash
    ''
      if pidof "hyprsunset"; then
        pkill hyprsunset
        ${pkgs.libnotify}/bin/notify-send "Night Shift Disabled" "Returning to full spectrum light. Filter disabled."
      else
        ${pkgs.hyprsunset}/bin/hyprsunset -t 4500 &
        ${pkgs.libnotify}/bin/notify-send "Night Shift Activated" "Welcome to the warm side. Blue light filtering is now active."
      fi
    '';
in {
  home.packages = with pkgs; [
    hyprsunset
    nightshift-toggle
  ];
}
