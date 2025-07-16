# - ## Hyprpanel
#-
#- Quick scripts to toggle, reload, hide & show hyprpanel.
#-
#- - `hyprpanel-toggle` - Toggle hyprpanel (hide/show).
#- - `hyprpanel-show` - Show hyprpanel.
#- - `hyprpanel-hide` - Hide hyprpanel.
#- - `hyprpanel-reload` - Reload hyprpanel.
{pkgs, ...}: let
  hyprpanel-toggle = pkgs.writeShellScriptBin "hyprpanel-toggle" ''
    hyprpanel toggleWindow bar-0
    hyprpanel toggleWindow bar-1
    hyprpanel toggleWindow bar-2
    hyprpanel toggleWindow bar-3
  '';

  hyprpanel-hide = pkgs.writeShellScriptBin "hyprpanel-hide" ''
    status=$(hyprpanel isWindowVisible bar-0)
    if [[ $status == "true" ]]; then
      hyprpanel toggleWindow bar-0
    fi
    status=$(hyprpanel isWindowVisible bar-1)
    if [[ $status == "true" ]]; then
      hyprpanel toggleWindow bar-1
    fi
  '';

  hyprpanel-show = pkgs.writeShellScriptBin "hyprpanel-show" ''
    status=$(hyprpanel isWindowVisible bar-0)
    if [[ $status == "false" ]]; then
      hyprpanel toggleWindow bar-0
    fi
    status=$(hyprpanel isWindowVisible bar-1)
    if [[ $status == "false" ]]; then
      hyprpanel toggleWindow bar-1
    fi
  '';

  hyprpanel-reload = pkgs.writeShellScriptBin "hyprpanel-reload" ''
    [ $(pgrep "hyprpanel") ] && pkill hyprpanel
    hyprctl dispatch exec hyprpanel
  '';
in {
  home.packages = [hyprpanel-toggle hyprpanel-reload hyprpanel-hide hyprpanel-show];
}
