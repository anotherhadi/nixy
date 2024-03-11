{ pkgs, config, ... }:

let
  homedir = config.home.homeDirectory;

  wallpaper = pkgs.writeShellScriptBin "wallpaper" ''
        WALLPAPER_FOLDER="${homedir}/Nextcloud/wallpaper"

        cd $WALLPAPER_FOLDER

        choosed_wallpaper=$(fd . |
        	fzf \
    		    --preview='kitty icat --clear --transfer-mode=memory --stdin=no --place=''${FZF_PREVIEW_COLUMNS}x''${FZF_PREVIEW_LINES}@0x0 {}' \
        		--preview-window=bottom,border-top \
        		--margin=1 \
        		--layout=reverse \
        		--border --border-label "Wallpaper" \
        		--info="hidden" \
        		--header="" \
        		--prompt='/ ' \
            --color="dark,fg+:white,bg+:-1,fg:white,bg:-1"\
            --color='prompt:grey,pointer:magenta,fg+:regular') || exit 1

        swww img $choosed_wallpaper
  '';

  menu = pkgs.writeShellScriptBin "menu" ''
    if pgrep wofi; then
    	pkill wofi
    else
    	wofi --show drun
    fi
  '';

  wireguard-import = pkgs.writeShellScriptBin "wireguard-import" ''
    nmcli connection import type wireguard file "$0"
  '';

  choose-output = pkgs.writeShellScriptBin "choose-output" ''
      function parse_sinks(){
        output=$(wpctl status)
        sinks=($(echo "$output" | sed 's/ │  //' | awk '/Sinks:/ {flag=1; next} /^$/ {flag=0} flag' | sed 's/ /-/g'))

        for sink in "''${sinks[@]}"; do

          id=""
          default=false
          sink=$(echo "$sink" | sed 's/-/ /g')
          sink_name=$(echo "$sink" | sed 's/\[vol:.*$//')

          if [[ $sink_name == "*"* ]]; then
            sink_name=$(echo "$sink_name" | sed 's/*//')
            default=true
          fi

          id=$(echo "$sink_name" | cut -d'.' -f1)
          sink_name=$(echo "$sink_name" | sed 's/^[ ]*//;s/[ ]*$//' )
          sink_name=$(echo "$sink_name" | cut -d'.' -f2 )

          if [[ $default == true ]];then
            printf "*%s (%d)" "$sink_name" "$id"
          else
            printf " %s (%d)" "$sink_name" "$id"
          fi
          printf "\n"
        done
    }


    choosed_sink=$(echo "$(parse_sinks)" | fzf \
      --margin=1 \
      --layout=reverse \
      --border --border-label "Wallpaper" \
      --info="hidden" \
      --header="" \
      --prompt='/ ' \
      --color="dark,fg+:white,bg+:-1,fg:white,bg:-1"\
      --color='prompt:grey,pointer:magenta,fg+:regular') || exit 1

    choosed_sink_id=$(echo "$choosed_sink" | sed 's/.*(\(.*\))/\1/')

    wpctl set-default $choosed_sink_id
  '';

in {
  home.packages = with pkgs; [ wallpaper menu wireguard-import choose-output ];
}
