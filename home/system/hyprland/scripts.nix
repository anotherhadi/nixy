# Compositor-level scripts: focus mode (temporarily flattens Hyprland's
# animations/gaps/decoration) and night shift (hyprsunset).
{
  pkgs,
  scripts,
  ...
}: {
  scripts.focus-toggle = pkgs.writeShellScriptBin "focus-toggle" ''
    if test -f "$XDG_RUNTIME_DIR/hypr-focus-mode"; then
      rm "$XDG_RUNTIME_DIR/hypr-focus-mode"
      OSD_TEXT="󰈈  Focus Off"
      ${scripts.waybar-osd}/bin/waybar-osd "$OSD_TEXT"
      ${pkgs.hyprland}/bin/hyprctl reload
      ${pkgs.hyprland}/bin/hyprctl dispatch exec waybar
    else
      touch "$XDG_RUNTIME_DIR/hypr-focus-mode"
      OSD_TEXT="󰈈  Focus On"
      ${scripts.waybar-osd}/bin/waybar-osd "$OSD_TEXT"
      ${pkgs.procps}/bin/pkill waybar || true
      ${pkgs.hyprland}/bin/hyprctl keyword animations:enabled false
      ${pkgs.hyprland}/bin/hyprctl keyword general:gaps_in 0
      ${pkgs.hyprland}/bin/hyprctl keyword general:gaps_out 0
      ${pkgs.hyprland}/bin/hyprctl keyword decoration:active_opacity 1
      ${pkgs.hyprland}/bin/hyprctl keyword decoration:inactive_opacity 1
      ${pkgs.hyprland}/bin/hyprctl keyword decoration:rounding 0
    fi
  '';

  scripts.nightshift-toggle = pkgs.writeShellScriptBin "nightshift-toggle" ''
    if ${pkgs.procps}/bin/pidof "hyprsunset" > /dev/null; then
      pkill hyprsunset
      OSD_TEXT="󰖔  Night Shift Off"
    else
      ${pkgs.hyprsunset}/bin/hyprsunset -t 4500 &
      OSD_TEXT="󰖔  Night Shift On"
    fi
    ${scripts.waybar-osd}/bin/waybar-osd "$OSD_TEXT"
  '';

  home.packages = [scripts.focus-toggle scripts.nightshift-toggle];

  xdg.desktopEntries = {
    focus-toggle = {
      name = "Focus Mode";
      exec = "${scripts.focus-toggle}/bin/focus-toggle";
      icon = "do-not-disturb-symbolic";
      comment = "Toggle focus mode";
      categories = ["System"];
      terminal = false;
    };

    nightshift-toggle = {
      name = "Night Shift";
      exec = "${scripts.nightshift-toggle}/bin/nightshift-toggle";
      icon = "night-light-symbolic";
      comment = "Toggle night shift";
      categories = ["System"];
      terminal = false;
    };
  };
}
