{pkgs, ...}: let
  nightshift-toggle =
    pkgs.writeShellScriptBin "nightshift-toggle"
    # bash
    ''
      if pidof "hyprsunset" > /dev/null; then
        pkill hyprsunset
        swayosd-client --custom-message "Night Shift Off" --custom-icon "night-light-symbolic"
      else
        ${pkgs.hyprsunset}/bin/hyprsunset -t 4500 &
        swayosd-client --custom-message "Night Shift On" --custom-icon "night-light-symbolic"
      fi
    '';
in {
  home.packages = with pkgs; [
    hyprsunset
    nightshift-toggle
  ];
}
