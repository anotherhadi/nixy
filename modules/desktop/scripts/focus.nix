# Focus mode: no gaps, no bar
{config, ...}: let
  inherit (config) theme;
in {
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      pkgs,
      scripts,
      ...
    }: let
      swaymsg = "${pkgs.sway}/bin/swaymsg";
    in {
      scripts.focus-toggle = pkgs.writeShellScriptBin "focus-toggle" ''
        state="$XDG_RUNTIME_DIR/focus-mode"
        set_gaps() {
          ${swaymsg} "gaps inner $1, gaps outer $2, gaps inner all set $1, gaps outer all set $2, bar mode $3"
        }
        if test -f "$state"; then
          rm "$state"
          OSD_TEXT="󰈈  Focus Off"
          set_gaps ${toString theme.gaps-in} ${toString theme.gaps-out} dock
        else
          touch "$state"
          OSD_TEXT="󰈈  Focus On"
          set_gaps 0 0 invisible
        fi
        ${scripts.osd}/bin/osd "$OSD_TEXT" focus
      '';

      launcher.focus-toggle.name = "Focus Mode";
    })
  ];
}
