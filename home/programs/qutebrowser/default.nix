{...}: {
  imports = [
    ./bookmarks.nix
  ];

  xdg.mimeApps.defaultApplications = {
    "text/html" = ["org.qutebrowser.qutebrowser.desktop"];
    "text/xml" = ["org.qutebrowser.qutebrowser.desktop"];
    "x-scheme-handler/http" = ["org.qutebrowser.qutebrowser.desktop"];
    "x-scheme-handler/https" = ["org.qutebrowser.qutebrowser.desktop"];
    "x-scheme-handler/unknown" = ["org.qutebrowser.qutebrowser.desktop"];
    "x-scheme-handler/about" = ["org.qutebrowser.qutebrowser.desktop"];
    "x-scheme-handler/qute" = ["org.qutebrowser.qutebrowser.desktop"];
  };

  programs.qutebrowser = {
    enable = true;
    loadAutoconfig = true;
    searchEngines = rec {
      startpage = "https://www.startpage.com/sp/search?q={}";

      mynixos = "https://mynixos.com/search?q={}";
      duckduckgo = "https://duckduckgo.com/?q={}";
      google = "https://google.com/search?hl=en&q={}";
      yandex = "https://yandex.com/search/?text={}";
      bing = "https://bing.com/search?q={}";

      # shortcuts
      g = google;
      n = mynixos;
      DEFAULT = startpage;
    };
    quickmarks = import ./quickmarks.nix;
    settings = {
      url = rec {
        default_page = "https://www.startpage.com";
        start_pages = [default_page];
      };
      new_instance_open_target = "window";
    };
  };
}
