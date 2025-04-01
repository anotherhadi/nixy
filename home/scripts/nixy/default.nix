# - ## Nixy
#- 
#- Nixy is a simple script that I use to manage my NixOS system. It's a simple script that provides a menu to rebuild, upgrade, update, collect garbage, clean boot menu, etc. 
#-
#- - `nixy` - UI wizard to manage the system.
#- - `nixy rebuild` - Rebuild the system.
#- - `nixy ...` - ... see the script for more commands.
{ pkgs, config, inputs, ... }:
let

  configDirectory = config.var.configDirectory;
  hostname = config.var.hostname;

  nixy = pkgs.writeShellScriptBin "nixy"
    # bash
    ''
      function exec() {
        $@
      }

      function ui(){
        DEFAULT_ICON="󰘳"

        # "icon;name;command"[]
        apps=(
          "󰑓;Rebuild;nixy rebuild"
          "󰦗;Upgrade;nixy upgrade"
          "󰚰;Update;nixy update"
          ";Collect Garbage;nixy gc"
          "󰍜;Clean Boot Menu;nixy cb"
          ";List generation;nixy listgen"
          "󰌌;Hyprland Keybindings;nvim ${configDirectory}/docs/KEYBINDINGS-HYPRLAND.md"
          "󰋩;Wallpapers;zen https://github.com/anotherhadi/nixy-wallpapers"
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
        exit $?
      }

      [[ $1 == "" ]] && ui

      if [[ $1 == "rebuild" ]];then
        cd ${configDirectory} && git add .
        sudo nixos-rebuild switch --flake ${configDirectory}#${hostname}
      elif [[ $1 == "upgrade" ]];then
        sudo nixos-rebuild switch --upgrade --flake '${configDirectory}#${hostname}'
      elif [[ $1 == "update" ]];then
        cd ${configDirectory} && nix flake update
      elif [[ $1 == "gc" ]];then
        cd ${configDirectory} && sudo nix-collect-garbage -d
      elif [[ $1 == "cb" ]];then
        sudo /run/current-system/bin/switch-to-configuration boot
      elif [[ $1 == "listgen" ]];then
        sudo nix-env -p /nix/var/nix/profiles/system --list-generations
      else
        echo "Unknown argument"
      fi
    '';

in { home.packages = [ nixy ]; }
