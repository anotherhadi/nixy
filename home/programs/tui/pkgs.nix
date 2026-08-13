{pkgs, ...}: {
  home.packages = with pkgs; [
    # I love TUIs
    caligula # User-friendly, lightweight TUI for disk imaging (ISO, USB BOOT)
    dysk # A terminal-based disk usage analyzer
    wikiman # Offline search engine for manual pages (arch wiki, tldr)
    tealdeer # Fast tldr client
    sttr # A minimalist CyberChef-like, cross-platform CLI app for performing various operations on strings
    slides # A terminal-based presentation tool that allows you to create and deliver presentations directly from the command line
    pom # Pomodoro timer in your terminal
    tabiew # A terminal-based CSV viewer and manipulator
    jless # A pager for JSON
    pkgs.nur.repos.anotherhadi.usbguard-tui # TUI for managing USBGuard rules
    pkgs.nur.repos.anotherhadi.sheets # Terminal based spreadsheet tool
    pkgs.nur.repos.anotherhadi.settuings # Terminal based settings (wifi, bluetooth, audio, ...)
    rainfrog # TODO: To test
    posting # TODO: To test
    newsboat # TODO: To test
    dooit # TODO: To test

    # I love CLIs
    httpie # Command-line HTTP client, a user-friendly cURL replacement
    gh # GitHub
    gh-dash # A terminal dashboard for GitHub
    figlet # Transform text into ASCII art
    pastel # Command-line tool to generate, analyze, convert and manipulate colors
    imagemagick # Image manipulation tool
    chafa # Image to ANSI/Unicode converter and more.

    # Just cool
    tty-solitaire
    bastet
    peaclock
    cbonsai
    pipes
    cmatrix
    fastfetch
  ];

  home.persistence."/persist".directories = [".config/gh" ".config/gh-dash"];
}
