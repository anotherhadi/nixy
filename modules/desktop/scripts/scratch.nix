# Scratch workspace (like Hyprland's special workspace, but tiled and in place of
# the current one): shows it on the focused output, or goes back when already there
{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({pkgs, ...}: {
      scripts.scratch-toggle = pkgs.writeShellApplication {
        name = "scratch-toggle";
        runtimeInputs = with pkgs; [sway jq];
        text = ''
          ws=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused) | .name')
          if [ "$ws" = scratch ]; then
            swaymsg workspace back_and_forth
          else
            output=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
            swaymsg "workspace scratch, move workspace to output \"$output\""
          fi
        '';
      };
    })
  ];
}
