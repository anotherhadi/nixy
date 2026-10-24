# Privacy: who is using the microphone, the camera or the screen
{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      lib,
      pkgs,
      scripts,
      ...
    }: {
      # One line per user: kind (mic, camera, screen) \t pid (or -) \t name
      scripts.privacy-users = pkgs.writeShellScript "privacy-users" ''
        export PATH=${lib.makeBinPath (with pkgs; [coreutils findutils jq pipewire procps])}:$PATH

        pw-dump 2>/dev/null | jq -r '
          def app: "\(.props["application.process.id"] // "-")\t\(.props["application.process.binary"] // .props["application.name"] // .props["node.name"] // "?")";
          [.[] | select(.type == "PipeWire:Interface:Node") | {id, state: .info.state, props: .info.props}] as $nodes
          | [.[] | select(.type == "PipeWire:Interface:Link") | .info] as $links
          | $nodes[] | select(.state == "running") | . as $src
          | (if .props["media.class"] == "Audio/Source" then "mic"
             elif .props["media.class"] == "Video/Source" then
               (if .props["device.api"] then "camera" else "screen" end)
             else empty end) as $kind
          | [$links[] | select(.["output-node-id"] == $src.id) | .["input-node-id"] as $in | $nodes[] | select(.id == $in)] as $users
          | (if $users == [] then $src else $users[] end)
          | "\($kind)\t\(app)"'

        # Webcam opened directly, outside PipeWire (most browsers, OBS...)
        for fd in $(find /proc/[0-9]*/fd -lname '/dev/video*' 2>/dev/null); do
          pid=''${fd#/proc/} && pid=''${pid%%/*}
          printf 'camera\t%s\t%s\n' "$pid" "$(cat "/proc/$pid/comm" 2>/dev/null)"
        done

        # Screen recorded straight from the compositor, without the portal
        for pid in $(pgrep -x wf-recorder); do
          printf 'screen\t%s\twf-recorder\n' "$pid"
        done
      '';

      # Live list of who uses what, for a terminal
      scripts.privacy-who = pkgs.writeShellScriptBin "privacy-who" ''
        export PATH=${lib.makeBinPath (with pkgs; [coreutils gawk])}:$PATH

        # No cursor, no line wrap (long command lines are cut at the edge)
        printf '\e[?25l\e[?7l'
        trap "printf '\e[?25h\e[?7h'" EXIT

        while :; do
          users=$(${scripts.privacy-users} | sort -u)
          printf '\e[H\e[2J'
          for kind in mic camera screen; do
            case $kind in
              mic) title='󰍬  Microphone' ;;
              camera) title='󰄀  Camera' ;;
              screen) title='󰹑  Screen' ;;
            esac
            lines=$(printf '%s\n' "$users" | awk -F'\t' -v k=$kind '$1 == k')
            if [ -z "$lines" ]; then
              printf '\e[1m%s\e[0m  \e[2mnot in use\e[0m\n\n' "$title"
              continue
            fi
            printf '\e[1;31m%s\e[0m\n' "$title"
            while IFS=$'\t' read -r _ pid name; do
              cmd=$(tr '\0' ' ' 2>/dev/null <"/proc/$pid/cmdline")
              printf '  %-8s %-20s \e[2m%s\e[0m\n' "$pid" "$name" "$cmd"
            done <<<"$lines"
            echo
          done
          printf '\e[2mq: quit\e[0m'
          if read -rsn1 -t1 key; then
            case $key in q | $'\e') exit ;; esac
          fi
        done
      '';

      launcher.privacy-who = {
        name = "Privacy: Who Uses Mic/Camera/Screen";
        exec = "${scripts.term}/bin/term ${scripts.privacy-who}/bin/privacy-who";
      };
    })
  ];
}
