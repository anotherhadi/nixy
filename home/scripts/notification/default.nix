{ pkgs, ... }:
let
  notif = pkgs.writeShellScriptBin "notif" ''
    # Shell script to send custom notifications
    NOTIF_FOLDER="/tmp/notif"
    sender_id=$1 # To overwrite existing notifications
    message=$2
    extraargs=""
    description=""
    if [[ $3 == "extraargs="* ]]; then
      extraargs=$(echo "$3" | sed 's/extraargs=//g')
    else
      description="$3"
      extraargs="$4"
    fi

    [[ -d "$NOTIF_FOLDER" ]] || mkdir $NOTIF_FOLDER
    [[ -f "$NOTIF_FOLDER/$sender_id" ]] || echo "0" > "$NOTIF_FOLDER/$sender_id"

    old_notification_id=$(cat "$NOTIF_FOLDER/$sender_id")

     ${pkgs.libnotify}/bin/notify-send "$message" \
     $extraargs \
    --replace-id="$old_notification_id" --print-id > "$NOTIF_FOLDER/$sender_id"
  '';

in { home.packages = [ notif ]; }
