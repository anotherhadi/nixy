# Hyprspace is a hyprland plugin that provides a workspaces overview (three-finger swipe up) and a workspace switcher (three-finger down).
{
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    plugins = [inputs.hyprspace.packages.${pkgs.system}.Hyprspace];
    settings = {
      plugin = {
        overview = {
          centerAligned = true;
          hideTopLayers = true;
          hideOverlayLayers = true;
          showNewWorkspace = true;
          exitOnClick = true;
          exitOnSwitch = true;
          drawActiveWorkspace = true;
          autoDrag = false;
        };
      };
    };
  };
}
