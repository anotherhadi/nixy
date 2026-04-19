{...}: {
  imports = [
    ./bookmarks
    ./search.nix
    ./keybindings.nix
    ./settings.nix
    ./userscripts.nix
  ];

  home.sessionVariables = {
    DEFAULT_BROWSER = "qutebrowser";
    BROWSER = "qutebrowser";
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = ["org.qutebrowser.qutebrowser.desktop"];
    "text/xml" = ["org.qutebrowser.qutebrowser.desktop"];
    "x-scheme-handler/http" = ["org.qutebrowser.qutebrowser.desktop"];
    "x-scheme-handler/https" = ["org.qutebrowser.qutebrowser.desktop"];
    "x-scheme-handler/unknown" = ["org.qutebrowser.qutebrowser.desktop"];
    "x-scheme-handler/about" = ["org.qutebrowser.qutebrowser.desktop"];
    "x-scheme-handler/qute" = ["org.qutebrowser.qutebrowser.desktop"];
  };

  xdg.desktopEntries.qutebrowser-private = {
    name = "Qutebrowser (Temp session)";
    genericName = "Web Browser";
    exec = "qutebrowser --temp-basedir %U";
    icon = "qutebrowser";
    categories = ["Network" "WebBrowser"];
  };

  programs.qutebrowser = {
    enable = true;
    loadAutoconfig = true;
  };
}
