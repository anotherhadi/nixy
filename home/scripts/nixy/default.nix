{ pkgs, config, ... }:

let

  nixy = pkgs.writeShellScriptBin "nixy" ''
    function exec() {
      $@
      # hyprctl dispatch exec $@
    }

    function ui(){
      DEFAULT_ICON="󰘳"

      # "icon;name;command"[]
      apps=(
        ";Rebuild;nixy-rebuild"
        ";Upgrade;nixy-upgrade"
        ";Update;nixy-update"
        ";Collect Garbage;nixy-gc"
        ";Clean Boot Menu;nixy-cb"
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
      nixy-rebuild
    elif [[ $1 == "upgrade" ]];then
      nixy-upgrade
    elif [[ $1 == "update" ]];then
      nixy-update
    elif [[ $1 == "gc" ]];then
      nixy-gc
    elif [[ $1 == "cb" ]];then
      nixy-cb
    fi
  '';

  nixy-rebuild = pkgs.writeShellScriptBin "nixy-rebuild" ''
    sudo nixos-rebuild switch --flake ${config.var.configDirectory}#${config.var.hostname}
  '';

  nixy-upgrade = pkgs.writeShellScriptBin "nixy-upgrade" ''
    sudo nixos-rebuild switch --upgrade --flake ${config.var.configDirectory}#${config.var.hostname}
  '';

  nixy-update = pkgs.writeShellScriptBin "nixy-update" ''
    cd ${config.var.configDirectory} && sudo nix flake update
  '';

  nixy-gc = pkgs.writeShellScriptBin "nixy-gc" ''
    cd ${config.var.configDirectory} && sudo nix-collect-garbage -d
  '';

  nixy-cb = pkgs.writeShellScriptBin "nixy-cb" ''
    sudo /run/current-system/bin/switch-to-configuration boot
  '';

in {
  home.packages = with pkgs; [
    nixy
    nixy-rebuild
    nixy-upgrade
    nixy-update
    nixy-gc
    nixy-cb
  ];
}
