{pkgs, ...}: {
  scripts.waybar-osd = pkgs.writeShellApplication {
    name = "waybar-osd";
    runtimeInputs = with pkgs; [procps coreutils];
    text = ''
      printf '%s' "$1" > "$XDG_RUNTIME_DIR/waybar-osd"
      pkill -f -RTMIN+8 '^waybar$' 2>/dev/null || true
    '';
  };

  scripts.waybar-osd-status = pkgs.writeShellApplication {
    name = "waybar-osd-status";
    runtimeInputs = with pkgs; [coreutils];
    text = ''
      file="$XDG_RUNTIME_DIR/waybar-osd"
      [ -f "$file" ] || exit 1
      mtime=$(stat -c %Y "$file" 2>/dev/null) || exit 1
      age=$(( $(date +%s) - mtime ))
      if [ "$age" -ge 3 ]; then
        rm -f "$file"
        exit 1
      fi
    '';
  };

  _module.args.osdPath = "$XDG_RUNTIME_DIR/waybar-osd";
}
