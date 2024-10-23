{ inputs, pkgs, ... }: {
  home.packages =
    [ inputs.hyprpolkitagent.packages."${pkgs.system}".hyprpolkitagent ];

  wayland.windowManager.hyprland.settings.exec-once =
    [ "systemctl --user start hyprpolkitagent" ];
}
