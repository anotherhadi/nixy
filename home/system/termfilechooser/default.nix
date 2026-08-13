# Use elio as the file picker for portal dialogs (browser "select file(s)" and
# "save download to..."). The backend is xdg-desktop-portal-termfilechooser,
# enabled system-wide in nixos/utils.nix (extraPortals + FileChooser routing).
{
  config,
  pkgs,
  ...
}: let
  wrapper = pkgs.writeShellScript "elio-wrapper" ''
    multiple="$1"
    directory="$2"
    save="$3"
    path="$4"
    out="$5"
    debug="$6"

    set -e

    if [[ "$debug" = 1 ]]; then
      set -x
    fi

    cmd="elio"
    termcmd="''${TERMCMD:-ghostty --gtk-single-instance=false --title=termfilechooser -e}"

    if [[ "$save" = "1" ]]; then
      set -- --chooser-file="$out" "$path"
    elif [[ "$directory" = "1" ]]; then
      set -- --chooser-file="$out" --cwd-file="$out.1" "$path"
    else
      set -- --chooser-file="$out" "$path"
    fi

    command="$termcmd $cmd"
    for arg in "$@"; do
      escaped=$(printf "%s" "$arg" | sed 's/"/\\"/g')
      command="$command \"$escaped\""
    done

    sh -c "$command"

    if [[ "$directory" = "1" ]]; then
      if [[ ! -s "$out" ]] && [[ -s "$out.1" ]]; then
        cat "$out.1" > "$out"
        rm "$out.1"
      else
        rm "$out.1"
      fi
    fi
  '';
  # ghostty must run in the foreground instead of handing off to the
  # single-instance daemon, otherwise the wrapper returns before you've picked
  # anything and the portal reads an empty selection.
  termcmd = "ghostty --gtk-single-instance=false --title=termfilechooser -e";
in {
  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${wrapper}
    default_dir=$HOME
    open_mode=suggested
    save_mode=suggested
    env=TERMCMD=${termcmd}
        PATH=${config.home.profileDirectory}/bin:/run/current-system/sw/bin:/run/wrappers/bin
  '';
}
