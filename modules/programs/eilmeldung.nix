# Eilmeldung: Feature-rich TUI RSS reader based on the news-flash library
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox;
in {
  flake.modules.nixos.eilmeldung = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({pkgs, ...}: let
        sandboxed = (mkSandbox pkgs).wrap {
          package = pkgs.unstable.eilmeldung;
          config = {sloth, ...}: {
            dbus = {
              enable = true;
              policies = {
                "org.freedesktop.portal.Desktop" = "talk"; # OpenURI (xdg-open)
                "org.freedesktop.Notifications" = "talk"; # notify_after_sync
              };
            };
            bubblewrap = {
              network = true;
              bind.rw = [
                (sloth.concat' sloth.homeDir "/.config/eilmeldung")
                (sloth.concat' sloth.homeDir "/.local/state/eilmeldung") # news-flash database
              ];
              sockets.wayland = true; # Clipboard (yank URL)
              env.NIXOS_XDG_OPEN_USE_PORTAL = "1";
            };
          };
        };

        # Bind sources must exist, otherwise the app writes into the sandbox's tmpfs and loses it
        eilmeldung = pkgs.writeShellScriptBin "eilmeldung" ''
          mkdir -p "$HOME/.config/eilmeldung" "$HOME/.local/state/eilmeldung"
          exec ${sandboxed}/bin/eilmeldung "$@"
        '';
      in {
        packages = [
          eilmeldung
          (pkgs.makeDesktopItem {
            name = "eilmeldung";
            desktopName = "eilmeldung";
            exec = "${pkgs.ghostty}/bin/ghostty +new-window -e ${eilmeldung}/bin/eilmeldung";
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
