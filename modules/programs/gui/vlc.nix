# VLC: video player, default for videos
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox mime;
in {
  flake.modules.nixos.vlc = {
    imports = [aspects.hjem];

    # Bind sources must exist, otherwise the app writes into the sandbox's tmpfs and loses it
    systemd.user.tmpfiles.rules = [
      "d %h/.config/vlc 0700 - - -"
      "d %h/.local/share/vlc 0700 - - -"
      "d %h/.cache/vlc 0700 - - -"
    ];

    hjem.extraModules = [
      ({pkgs, ...}: let
        # Sandboxed: no network, no D-Bus, reads the user dirs, writes only its own state
        vlc = (mkSandbox pkgs).wrap {
          package = pkgs.vlc;
          gui = true;
          config = {sloth, ...}: {
            # The portal hands it files through the document store under the .desktop ID:
            # rename the .desktop to the app ID so both match (mime default below)
            flatpak = {
              appId = "org.videolan.VLC";
              desktopFile = "vlc.desktop";
            };
            bubblewrap = {
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
              bind.rw = map (d: sloth.concat' sloth.homeDir "/${d}") [".config/vlc" ".local/share/vlc" ".cache/vlc"];
              sockets = {
                pipewire = true;
                pulse = true;
              };
            };
          };
        };
      in {
        packages = [vlc];

        xdg.mime-apps = mime.defaultFor "org.videolan.VLC.desktop" mime.types.video;
      })
    ];
  };
}
