{config, ...}: {
  programs.qutebrowser = {
    settings = {
      url = rec {
        default_page = "file://${config.xdg.dataHome}/qutebrowser/bookmarks.html";
        start_pages = [default_page];
      };
      new_instance_open_target = "window";
      "tabs.last_close" = "close";
      "statusbar.widgets" = ["keypress" "url" "progress"];

      # Adblock
      "content.blocking.enabled" = true;
      "content.blocking.method" = "adblock";
      "content.blocking.adblock.lists" = [
        "https://easylist.to/easylist/easylist.txt"
        "https://easylist.to/easylist/easyprivacy.txt"
        "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt"
      ];

      # Clipboard access (needed for Excalidraw, Cyberchef, etc.)
      "content.javascript.clipboard" = "access";

      # Downloads
      "downloads.location.directory" = "~/Downloads";
      "downloads.location.prompt" = false;

      # Editor (Ctrl+e in text fields)
      "editor.command" = ["ghostty" "-e" "nvim" "{}"];

      # Tabs
      "tabs.show" = "switching";

      # Scrollbar
      "scrolling.bar" = "never";

      # Statusbar
      "statusbar.show" = "in-mode";

      # Privacy
      "content.geolocation" = false;
      "content.cookies.accept" = "no-3rdparty";
    };

    extraConfig = ''
      c.statusbar.padding = {'top': 6, 'bottom': 6, 'left': 8, 'right': 8}
      c.tabs.padding = {'top': 6, 'bottom': 6, 'left': 8, 'right': 8}
    '';
  };
}
