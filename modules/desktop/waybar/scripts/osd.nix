# On-screen display in the bar: `waybar-osd "text" [name]` shows a message for ~3s.
# Each name is one file in $XDG_RUNTIME_DIR/osd, so several programs can show a
# message at once; the bar (waybar or swaybar) shows them all, separated.
{config, ...}: let
  inactive = "#${config.theme.colors.base03}";
in {
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({pkgs, ...}: {
      scripts.waybar-osd = pkgs.writeShellApplication {
        name = "waybar-osd";
        runtimeInputs = with pkgs; [procps coreutils];
        text = ''
          dir="$XDG_RUNTIME_DIR/osd"
          name="''${2:-default}"
          mkdir -p "$dir"
          printf '%s' "$1" > "$dir/.$name.tmp"
          mv "$dir/.$name.tmp" "$dir/$name"
          pkill -f -RTMIN+8 '^waybar$' 2>/dev/null || true
          pkill -x -RTMIN+8 swaybar-status 2>/dev/null || true
        '';
      };

      # Prints the live messages (pango markup), fails when there is none
      scripts.waybar-osd-status = pkgs.writeShellApplication {
        name = "waybar-osd-status";
        runtimeInputs = with pkgs; [coreutils gnused];
        text = ''
          dir="$XDG_RUNTIME_DIR/osd"
          [ -d "$dir" ] || exit 1
          now=$(date +%s)
          out=""
          for file in "$dir"/*; do
            [ -f "$file" ] || continue
            mtime=$(stat -c %Y "$file" 2>/dev/null) || continue
            if [ $((now - mtime)) -ge 3 ]; then
              rm -f "$file"
              continue
            fi
            text=$(sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' "$file")
            out="''${out:+$out  <span color='${inactive}'>|</span>  }$text"
          done
          [ -n "$out" ] || exit 1
          printf '%s\n' "$out"
        '';
      };
    })
  ];
}
