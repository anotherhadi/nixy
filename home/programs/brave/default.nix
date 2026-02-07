{
  pkgs,
  lib,
  ...
}: {
  programs.brave = {
    enable = true;
    commandLineArgs = [
      "--no-default-browser-check"
    ];
  };

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.brave}/bin/brave";
  };

  xdg.desktopEntries = {
    brave-incognito = {
      name = "Brave (Private window)";
      genericName = "Navigateur Web";
      exec = "brave --incognito";
      icon = "brave-browser";
      terminal = false;
      categories = ["Network" "WebBrowser"];
      mimeType = ["text/html" "text/xml"];
    };
    brave-tor = {
      name = "Brave (Private window w/Tor)";
      genericName = "Navigateur Web";
      exec = "brave --tor";
      icon = "brave-browser";
      terminal = false;
      categories = ["Network" "WebBrowser"];
    };
  };
}
