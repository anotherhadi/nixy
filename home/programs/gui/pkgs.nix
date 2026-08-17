{
  pkgs,
  config,
  lib,
  ...
}: {
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

  home.persistence."/persist" = lib.mkIf (config.var.impermanenceEnabled or false) {
    directories = [
      ".config/ticktick"
      ".config/Signal"
      ".config/obsidian"
    ];
  };
}
