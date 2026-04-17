{
  pkgs,
  pkgs-stable,
  ...
}: {
  home.packages = with pkgs-stable; [
    vlc # Video player
    blanket # White-noise app
    obsidian # Note taking app
    textpieces # Manipulate texts
    resources # Ressource monitor
    gnome-clocks # Clocks app
    gnome-text-editor # Basic graphic text editor
    ticktick # Todo app
    pinta # Image editor
    onlyoffice-desktopeditors # Office suite

    signal-desktop # Messaging app
    element-desktop # Messaging app
  ];
}
