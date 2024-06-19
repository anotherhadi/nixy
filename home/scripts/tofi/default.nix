{ pkgs, config, ... }:

let

  tofi = pkgs.writeShellScriptBin "tofi" ''
    function exec() {
      $@
      # hyprctl dispatch exec $@
    }

    function ui(){
      DEFAULT_ICON="󰘳"

      # "icon;name;command"[]
      apps=(
        ";Nixy;nixy"
        ";Nerdfont;nerdfont-fzf"
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

in { home.packages = with pkgs; [ tofi ]; }
