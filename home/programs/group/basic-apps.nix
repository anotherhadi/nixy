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

    # I love TUIs
    caligula # User-friendly, lightweight TUI for disk imaging (ISO, USB BOOT)
    browsh # A modern text-based browser that renders anything that a modern browser can; including HTML5, CSS3, JS, video and WebGL. It runs in a terminal and can be used remotely over SSH.
    pastel # Command-line tool to generate, analyze, convert and manipulate colors
    dysk # A terminal-based disk usage analyzer, similar to 'du' but with a more user-friendly interface and additional features.
    wikiman # Offline search engine for manual pages
  ];
}
