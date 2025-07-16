# - ## Notif
#-
# This file provides a script to send custom notifications using `notify-send`.
#-
#- - `notif {id} {title} {description}` - Sends a notification
{pkgs, ...}: let
  notif =
    pkgs.writeShellScriptBin "notif" # bash
    
    ''
      # Shell script to send custom notifications
      # Usage: notif "sender_id" "message" ["description"]
      NOTIF_FOLDER="/tmp/notif"
      sender_id=$1 # To overwrite existing notifications
      title=$2
      description=$3

      [[ -d "$NOTIF_FOLDER" ]] || mkdir $NOTIF_FOLDER
      [[ -f "$NOTIF_FOLDER/$sender_id" ]] || (echo "0" > "$NOTIF_FOLDER/$sender_id")

      old_notification_id=$(cat "$NOTIF_FOLDER/$sender_id")
      [[ -z "$old_notification_id" ]] && old_notification_id=0

       ${pkgs.libnotify}/bin/notify-send \
      --replace-id="$old_notification_id" --print-id \
      --app-name="$sender_id" \
      "$title" \
      "$description" \
      > "$NOTIF_FOLDER/$sender_id"
    '';
in {home.packages = [pkgs.libnotify notif];}
