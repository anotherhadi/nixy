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
          "󰍜;Clean;nixy clean"
          "󰌌;Hyprland Keybindings;nvim ${configDirectory}/docs/KEYBINDINGS-HYPRLAND.md"
          "󰋩;Wallpapers;nvim ${inputs.nixy-wallpapers}/docs/MOBILE-VIEW.md"
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
        ${pkgs.nh}/bin/nh os switch ${configDirectory} --hostname ${hostname}
      elif [[ $1 == "upgrade" ]];then
        ${pkgs.nh}/bin/nh os switch ${configDirectory} --hostname ${hostname} --update
      elif [[ $1 == "clean" ]];then
        cd ${configDirectory} && ${pkgs.nh}/bin/nh clean all
      elif [[ $1 == "remote" ]];then
        cd ~/.config/nixos && git add . && git commit -m "update" && git push
        ssh jack -S -C "cd /home/hadi/.config/nixos && git pull && sudo -S nixos-rebuild switch --flake ~/.config/nixos#jack"
      else
        echo "Unknown argument"
      fi
    '';

in { home.packages = [ nixy ]; }
