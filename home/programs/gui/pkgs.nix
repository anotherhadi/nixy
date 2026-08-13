{pkgs, ...}: {
  home.packages = with pkgs; [
    vlc # Video player
    obsidian # Note taking app
    textpieces # Manipulate texts
    resources # Resource monitor
    gnome-clocks # Clocks app
    gnome-text-editor # Basic graphic text editor
    ticktick # Todo app
    pinta # Image editor
    switcheroo # Convert images between different formats
    onlyoffice-desktopeditors # Office suite
    blanket # Listen to different sounds
    signal-desktop # Messaging app
    thunar # File explorer
  ];
}
