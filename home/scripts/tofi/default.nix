{ pkgs, config, ... }:

let

  tofi = pkgs.writeShellScriptBin "tofi" ''
    hyprexec="hyprctl dispatch exec"
    function exec() {
      $@
    }

    function ui(){
      DEFAULT_ICON="󰘳"

      # "icon;name;command"[]
      apps=(
        ";Nixy;nixy"
        ";Nerdfont FZF;nerdfont-fzf"
        ";Brightness Up;brightness-up"
        ";Brightness Down;brightness-down"
        ";Sound Up;sound-up"
        ";Sound Down;sound-down"
        ";Sound Toggle Mute;sound-toggle"
        ";Sound Change Output;sound-output"
        ";Caffeine;caffeine"
        ";Night Shift Toggle;night-shift-toggle"
        ";Firefox;$hyprexec firefox"
        ";Qutebrowser;$hyprexec qutebrowser"
        ";Kitty;$hyprexec kitty"
        ";Thunar;$hyprexec thunar"
        ";Powermenu;powermenu"
        ";Wofi;menu"
        ";Lock;lock"
        ";Bitwarden;$hyprexec bitwarden"
        ";Clock; peaclock"
        ";Nextcloud;$hyprexec nextcloud"
        ";Spotify;$hyprexec spotify"
        ";Btop;btop"
        ";Cava;cava"
        ";Discord;$hyprexec discord"
        ";Vlc;$hyprexec vlc"
        ";Obsidian;$hyprexec obsidian"
      )

      # Apply default icons if empty:
      for i in "''${!apps[@]}"; do
        apps[i]=$(echo "''${apps[i]}" | sed 's/^;/'$DEFAULT_ICON';/')
      done

      fzf_result=$(printf "%s\n" "''${apps[@]}" | awk -F ';' '{print $1" "$2}' | fzf)
      [[ -z $fzf_result ]] && exit 0
      fzf_result=''${fzf_result/ /;}
      line=$(printf "%s\n" "''${apps[@]}" | grep "$fzf_result")
      command=$(echo "$line" | sed 's/^[^;]*;//;s/^[^;]*;//')

      exec "$command"
      exit 0
    }

    ui
  '';

in { home.packages = [ tofi ]; }
