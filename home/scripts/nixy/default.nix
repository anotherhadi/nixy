{ pkgs, config, ... }:
let
  nixy = pkgs.writeShellScriptBin "nixy" ''
    function exec() {
      $@
    }

    function ui(){
      DEFAULT_ICON="󰘳"

      # "icon;name;command"[]
      apps=(
        ";Rebuild;nixy rebuild"
        ";Upgrade;nixy upgrade"
        ";Update;nixy update"
        ";Collect Garbage;nixy gc"
        ";Clean Boot Menu;nixy cb"
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

    [[ $1 == "" ]] && ui

    if [[ $1 == "rebuild" ]];then
      sudo nixos-rebuild switch --flake ${config.var.configDirectory}#${config.var.hostname}
    elif [[ $1 == "upgrade" ]];then
      sudo nixos-rebuild switch --upgrade --flake ${config.var.configDirectory}#${config.var.hostname}
    elif [[ $1 == "update" ]];then
      cd ${config.var.configDirectory} && sudo nix flake update
    elif [[ $1 == "gc" ]];then
      cd ${config.var.configDirectory} && sudo nix-collect-garbage -d
    elif [[ $1 == "cb" ]];then
      sudo /run/current-system/bin/switch-to-configuration boot
    elif [[ $1 == "remote" ]];then
      cd ~/.config/nixos && git add . && git commit -m "update" && git push
      ssh jack -S -C "cd /home/hadi/.config/nixos && git pull && sudo -S nixos-rebuild switch --flake ~/.config/nixos#jack"
    else
      echo "Unknown argument"
    fi
  '';

in { home.packages = [ nixy ]; }
