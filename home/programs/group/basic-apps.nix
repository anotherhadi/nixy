{
  pkgs,
  pkgs-stable,
  pkgs-nur-hadi,
  ...
}: {
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

    # I love TUIs
    caligula # User-friendly, lightweight TUI for disk imaging (ISO, USB BOOT)
    browsh # A modern text-based browser that renders anything that a modern browser can. It runs in a terminal and can be used remotely over SSH
    dysk # A terminal-based disk usage analyzer
    wikiman # Offline search engine for manual pages (arch wiki, tldr)
    tealdeer # Fast tldr client
    sttr # Minimalist "cyberchef" like. Cross-platform, cli app to perform various operations on string
    wiremix # Simple TUI mixer for PipeWire
    slides # A terminal-based presentation tool that allows you to create and deliver presentations directly from the command line
    pom # Pomodoro timer in your terminal
    pkgs.wifitui # TUI for managing wifi
    pkgs-nur-hadi.usbguard-tui # TUI for managing USBGuard rules
    pkgs-nur-hadi.sheets # Terminal based spreadsheet tool

    # I love CLIs
    httpie # Command-line HTTP client, a user-friendly cURL replacement
    gh # GitHub
    gh-dash # A terminal dashboard for GitHub
    figlet # Transform text into ASCII art
    pastel # Command-line tool to generate, analyze, convert and manipulate colors
    imagemagick # Image manipulation tool
    chafa # Image to ANSI/Unicode converter and more.
  ];
}
