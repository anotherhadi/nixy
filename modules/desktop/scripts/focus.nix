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
        if test -f "$state"; then
          rm "$state"
          OSD_TEXT="󰈈  Focus Off"
          ${swaymsg} "gaps inner all set ${toString theme.gaps-in}, gaps outer all set ${toString theme.gaps-out}, bar mode dock"
        else
          touch "$state"
          OSD_TEXT="󰈈  Focus On"
          # Existing workspaces only: new ones get the configured gaps
          ${swaymsg} "gaps inner all set 0, gaps outer all set 0, bar mode invisible"
        fi
        ${scripts.osd}/bin/osd "$OSD_TEXT" focus
      '';

      launcher.focus-toggle.name = "Focus Mode";
    })
  ];
}
