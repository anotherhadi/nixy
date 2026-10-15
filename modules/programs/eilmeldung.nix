# Feature-rich TUI RSS reader based on the news-flash library
{aspects, ...}: {
  flake.modules.nixos.eilmeldung = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({pkgs, ...}: {
        packages = [
          pkgs.unstable.eilmeldung
          (pkgs.makeDesktopItem {
            name = "eilmeldung";
            desktopName = "eilmeldung";
            exec = "${pkgs.ghostty}/bin/ghostty +new-window -e ${pkgs.unstable.eilmeldung}/bin/eilmeldung";
            comment = "Feature-rich TUI RSS reader";
            categories = ["Network" "ConsoleOnly"];
            terminal = false;
            keywords = ["rss" "feed" "news" "reader"];
          })
        ];

        persist.directories = [".config/eilmeldung"];
      })
    ];
  };
}
