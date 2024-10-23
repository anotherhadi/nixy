{ inputs, pkgs, ... }: {
  home.packages =
    [ inputs.hyprpolkitagent.packages."${pkgs.system}".hyprpolkitagent ];

  wayland.windowManager.hyprland.exec-once =
    [ "systemctl --user start hyprpolkitagent" ];
}
