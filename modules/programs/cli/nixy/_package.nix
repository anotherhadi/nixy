# fzf menu over nh; extra args are passed through (nixy rebuild --dry, ...)
{
  writeShellApplication,
  fzf,
  git,
  nh,
  configDirectory,
}:
writeShellApplication {
  name = "nixy";
  runtimeInputs = [fzf git nh];
  text = ''
    cmd=''${1:-}
    [[ $# -gt 0 ]] && shift
    if [[ -z $cmd ]]; then
      cmd=$(printf '%s\n' "󰑓 rebuild" "󰐊 test" "󰚰 update" "󰘳 gc" "󰍜 cb" "󰘳 listgen" \
        | fzf | cut -d' ' -f2) || exit 0
    fi

    cd "${configDirectory}"
    case $cmd in
      # New files must be in the git index for the flake to see them
      rebuild) git add -A && nh os switch . "$@" ;;
      test) git add -A && nh os test . "$@" ;;
      update) nix flake update "$@" ;;
      gc) nh clean all "$@" ;;
      # Rewrite boot entries so collected generations leave the boot menu
      cb) sudo /run/current-system/bin/switch-to-configuration boot ;;
      listgen) nh os info "$@" ;;
      *)
        echo "usage: nixy [rebuild|test|update|gc|cb|listgen] [args...]" >&2
        exit 1
        ;;
    esac
  '';
}
