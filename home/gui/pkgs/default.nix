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
    # TODO: Will try signal TUI again
    signal-desktop # Messaging app
    ticktick # Todo app

    # TODO: Zatura ? Avec home manager pour stylix

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
