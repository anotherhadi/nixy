# Feature-rich TUI RSS reader based on the news-flash library
{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = [
    pkgs-unstable.eilmeldung
  ];

  home.persistence."/persist" = lib.mkIf (config.var.impermanenceEnabled or false) {
    directories = [".config/eilmeldung"];
  };

  xdg.desktopEntries.eilmeldung = {
    name = "eilmeldung";
    exec = "${pkgs.ghostty}/bin/ghostty +new-window -e ${pkgs-unstable.eilmeldung}/bin/eilmeldung";
    comment = "Feature-rich TUI RSS reader";
    categories = ["Network" "ConsoleOnly"];
    terminal = false;
    settings.Keywords = "rss;feed;news;reader";
  };
}
