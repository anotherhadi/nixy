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
    blanket # Listen to different sounds
    signal-desktop # Messaging app
    librewolf # Backup browser
    imagemagick # Image manipulation tool

    # I love TUIs
    caligula # User-friendly, lightweight TUI for disk imaging (ISO, USB BOOT)
    browsh # A modern text-based browser that renders anything that a modern browser can. It runs in a terminal and can be used remotely over SSH
    pastel # Command-line tool to generate, analyze, convert and manipulate colors
    dysk # A terminal-based disk usage analyzer
    wikiman # Offline search engine for manual pages (arch wiki, tldr)
    tealdeer # Fast tldr client
    sttr # Minimalist "cyberchef" like. Cross-platform, cli app to perform various operations on string
    httpie # Command-line HTTP client, a user-friendly cURL replacement
    wiremix # Simple TUI mixer for PipeWire
    impala # TUI for managing wifi
  ];
}
