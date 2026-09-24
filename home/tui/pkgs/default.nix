{
  pkgs,
  pkgs-unstable,
  config,
  lib,
  ...
}: {
  programs = {
    cava.enable = true;
    gh.enable = true; # Github-cli # TODO: config
  };

  # TODO: Desktop actions for: cava, gh, usbguard-tui, monitui, proton-vpn-tui, pomo, eilmeldung, andcli
  # Smassh, minesweep-rs,

  # TODO: "perch" for mastodon/bluesky tui client

  home.packages = with pkgs; [
    # I love TUIs
    caligula # User-friendly, lightweight TUI for disk imaging (ISO, USB BOOT)
    sttr # A minimalist CyberChef-like, cross-platform CLI app for performing various operations on strings
    slides # A terminal-based presentation tool that allows you to create and deliver presentations directly from the command line
    tabiew # A terminal-based CSV viewer and manipulator
    jless # A pager for JSON
    dua # Tool to conveniently learn about the disk usage of directories
    mcat # Cat command for documents / images / videos and more
    lazyjournal
    vhs # Create GIF from the command-line
    pkgs.nur.repos.anotherhadi.usbguard-tui # TUI for managing USBGuard rules
    pkgs.nur.repos.anotherhadi.settuings # Terminal based settings (wifi, bluetooth, audio, ...)
    pkgs.nur.repos.anotherhadi.fztea # Flipper Zero from the terminal
    pkgs.nur.repos.anotherhadi.monitui # Edit hyprland's monitor configuration
    pkgs.nur.repos.anotherhadi.proton-vpn-tui
    pkgs-unstable.pomo # Pomodoro timer in your terminal
    pkgs-unstable.eilmeldung # TODO: To conf when on home manager stable
    pkgs-unstable.andcli # TODO: To conf when on home manager stable

    httpie # Command-line HTTP client, a user-friendly cURL replacement
    figlet # Transform text into ASCII art
    pastel # Command-line tool to generate, analyze, convert and manipulate colors
    imagemagick # Image manipulation tool
    chafa # Image to ANSI/Unicode converter and more.
    proton-vpn-cli
    pkgs-unstable.yt-dlp

    # Just cool
    tty-solitaire
    bastet
    peaclock
    cbonsai
    pipes
    cmatrix
    fastfetch
    smassh # typing test, 10fastfinger like
  ];

  home.persistence."/persist" = lib.mkIf (config.var.impermanenceEnabled or false) {
    directories = [".config/gh" ".config/gh-dash"];
  };
}
