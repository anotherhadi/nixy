# OnlyOffice: office suite, default for office documents
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox mime;
in {
  flake.modules.nixos.onlyoffice = {
    imports = [aspects.hjem];

    systemd.user.tmpfiles.rules = [
      "d %h/.config/onlyoffice 0700 - - -"
      "d %h/.local/share/onlyoffice 0700 - - -"
    ];

    hjem.extraModules = [
      ({pkgs, ...}: let
        # Sandboxed: no network, no D-Bus, reads the user dirs, writes ~/Documents and ~/Downloads
        # FHS env: its own bwrap runs nested in this one
        onlyoffice = (mkSandbox pkgs).wrap {
          package = pkgs.onlyoffice-desktopeditors;
          gui = true;
          config = {sloth, ...}: {
            flatpak = {
              appId = "org.onlyoffice.desktopeditors";
              desktopFile = "onlyoffice-desktopeditors.desktop";
            };
            bubblewrap = {
              # X11 only (bundled Qt has no Wayland plugin): runs on Xwayland
              sockets.x11 = true;
              bind.ro = map (d: sloth.concat' sloth.homeDir "/${d}") [
                # XDG user dirs (desktop/user-dirs.nix)
                "Cyber"
                "Documents"
                "Downloads"
                "Music"
                "Notes"
                "Pictures"
                "Projects"
                "Videos"
              ];
              bind.rw = map (d: sloth.concat' sloth.homeDir "/${d}") [
                ".config/onlyoffice"
                ".local/share/onlyoffice"
                "Documents"
                "Downloads"
              ];
            };
          };
        };
      in {
        packages = [onlyoffice];

        xdg.mime-apps = mime.defaultFor "org.onlyoffice.desktopeditors.desktop" mime.types.office;
      })
    ];
  };
}
