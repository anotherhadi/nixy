{pkgs, ...}: {
  home.packages = with pkgs; [
    vlc # Video player
    obsidian # Note taking app
    pinta # Image editor
    onlyoffice-desktopeditors # Office suite
    blanket # Listen to different sounds
    signal-desktop # Messaging app
    ticktick # Todo app

    # Backup
    thunar
    gnome-text-editor
  ];

  home.persistence."/persist".directories = [
    ".config/ticktick"
    ".config/Signal"
    ".config/obsidian"
  ];
}
