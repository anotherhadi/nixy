{ pkgs, config, ... }:

let
  homedir = config.home.homeDirectory;
  increments = "5";

  sound-change = pkgs.writeShellScriptBin "sound-change" ''
    sleep 0.05

    [[ $1 == "mute" ]] && wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    [[ $1 == "up" ]] && wpctl set-volume @DEFAULT_AUDIO_SINK@ "$2%+"
    [[ $1 == "down" ]] && wpctl set-volume @DEFAULT_AUDIO_SINK@ "$2%-"

    sink_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

    volume=$(echo "$(echo "$sink_info" | awk '{print $2}' | sed 's/%//')*100" | bc -l | xargs printf "%.0f")
    muted=false
    if [[ $sink_info == *"MUTED"* ]]; then
      muted=true
    fi

    message=""
    if [ $muted = true ]; then
      message="󰖁 Muted"
    else
      message="󰕾 Volume: $volume%"
    fi

    ${pkgs.libnotify}/bin/notify-send "$message" \
      -h int:value:"$volume" \
      --replace-id="$(cat "/tmp/nixy-notification" 2>/dev/null || echo 0)" --print-id > "/tmp/nixy-notification"
  '';

  sound-up = pkgs.writeShellScriptBin "sound-up" ''
    sound-change up ${increments}
  '';

  sound-down = pkgs.writeShellScriptBin "sound-down" ''
    sound-change down ${increments}
  '';

  sound-toggle = pkgs.writeShellScriptBin "sound-toggle" ''
    sound-change mute
  '';

  sound-output = pkgs.writeShellScriptBin "sound-output" ''
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


    choosed_sink=$(echo "$(parse_sinks)" | ${pkgs.fzf}/bin/fzf \
      --border-label "Choose sound output" ) || exit 1

    choosed_sink_id=$(echo "$choosed_sink" | sed 's/.*(\(.*\))/\1/')

    wpctl set-default $choosed_sink_id
  '';

in {
  home.packages = with pkgs; [
    sound-output
    sound-change
    sound-up
    sound-down
    sound-toggle
  ];
}
