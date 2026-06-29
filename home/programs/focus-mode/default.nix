{pkgs, ...}: let
  focus-toggle =
    pkgs.writeShellScriptBin "focus-toggle"
    # bash
    ''
      if test -f /tmp/hypr-focus-mode; then
        rm /tmp/hypr-focus-mode
        hyprctl reload
        hyprctl dispatch exec waybar
        swayosd-client --custom-message "Focus Mode Off" --custom-icon "do-not-disturb-symbolic"
      else
        touch /tmp/hypr-focus-mode
        pkill waybar || true
        hyprctl keyword animations:enabled false
        hyprctl keyword general:gaps_in 0
        hyprctl keyword general:gaps_out 0
        hyprctl keyword decoration:active_opacity 1
        hyprctl keyword decoration:inactive_opacity 1
        hyprctl keyword decoration:rounding 0
        swayosd-client --custom-message "Focus Mode On" --custom-icon "do-not-disturb-symbolic"
      fi
    '';
in {
  home.packages = [focus-toggle];
}
