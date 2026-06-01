{pkgs-stable, ...}: {
  home.packages = with pkgs-stable; [
    vlc # Video player
    obsidian # Note taking app
    textpieces # Manipulate texts
    resources # Ressource monitor
    gnome-clocks # Clocks app
    gnome-text-editor # Basic graphic text editor
    ticktick # Todo app
    pinta # Image editor
    switcheroo # Convert images between different formats
    onlyoffice-desktopeditors # Office suite

    signal-desktop # Messaging app
    librewolf # Backup browser

    caligula # User-friendly, lightweight TUI for disk imaging (ISO, USB BOOT)
  ];
}
