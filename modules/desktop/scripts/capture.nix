# Screen capture: screenshots, recording, color picker
{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      pkgs,
      scripts,
      ...
    }: let
      updateOsd = ''
        ${scripts.osd}/bin/osd "$OSD_TEXT" capture
      '';
    in {
      scripts.color-pick = pkgs.writeShellScriptBin "color-pick" ''
        # hyprpicker -a already copies the color to the clipboard.
        color=$(${pkgs.hyprpicker}/bin/hyprpicker -a 2>/dev/null)
        if [ -n "$color" ]; then
          OSD_TEXT="󰈊  $color"
        fi
        ${updateOsd}
      '';

      # Opens the latest screenshot in Satty
      scripts.screenshot-edit = pkgs.writeShellScriptBin "screenshot-edit" ''
        conf="''${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs"
        [ -f "$conf" ] && . "$conf"
        dir="''${XDG_SCREENSHOTS_DIR:-''${XDG_PICTURES_DIR:-$HOME}}"

        file=$(ls -t "$dir"/*.png 2>/dev/null | head -n 1)
        if [ -z "$file" ]; then
          OSD_TEXT="󰹑  No screenshot"
          ${updateOsd}
          exit 0
        fi
        ${pkgs.satty}/bin/satty --filename "$file" --output-filename "$file"
      '';

      scripts.record-toggle = pkgs.writeShellScriptBin "record-toggle" ''
        export PATH=${pkgs.lib.makeBinPath (with pkgs; [coreutils jq libnotify procps slurp sway wf-recorder])}:$PATH
        redraw() { pkill -x -RTMIN+8 swaybar-status 2>/dev/null || true; }

        if pgrep -x wf-recorder >/dev/null; then
          pkill -INT -x wf-recorder
          exit 0
        fi

        geom=$(swaymsg -t get_tree \
          | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' \
          | slurp -o) || exit 0
        dir="$HOME/Videos"
        mkdir -p "$dir"
        file="$dir/rec-$(date +%Y%m%d-%H%M%S).mp4"
        (
          wf-recorder -g "$geom" -f "$file" >/dev/null 2>&1
          redraw
          notify-send -i media-record "Recording saved" "''${file/#$HOME/\~}"
        ) &
        sleep 0.2
        redraw
      '';

      launcher.screenshot = {
        name = "Screenshot";
        exec = "${pkgs.sway-contrib.grimshot}/bin/grimshot --notify savecopy anything";
      };
      launcher.color-pick.name = "Pick Color";
      launcher.screenshot-edit.name = "Annotate Last Screenshot";
      launcher.record-toggle.name = "Screen Recording";

      packages = with pkgs; [hyprpicker satty wf-recorder sway-contrib.grimshot];
    })
  ];
}
