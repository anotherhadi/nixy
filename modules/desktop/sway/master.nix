{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({pkgs, ...}: let
      sway-master = pkgs.writers.writePython3Bin "sway-master" {
        libraries = [pkgs.python3Packages.i3ipc];
        flakeIgnore = ["E501"];
      } (builtins.readFile ./_master.py);
    in {
      sway.config = ''
        exec ${sway-master}/bin/sway-master
        default_orientation horizontal
        workspace_layout default

        # Swap the focused window with the master one
        bindsym $mod+Shift+Return exec ${sway-master}/bin/sway-master swap
      '';
    })
  ];
}
