# Kew is a TUI audio player
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox mime;
in {
  flake.modules.nixos.kew = {
    imports = [aspects.hjem];

    systemd.user.tmpfiles.rules = [
      "d %h/.config/kew 0700 - - -"
      "d %h/.local/state/kew 0700 - - -"
    ];

    hjem.extraModules = [
      ({pkgs, ...}: let
        # Sandboxed: no network, reads the user dirs, writes its
        # config, its state and ~/Music (favorites playlist)
        kew = (mkSandbox pkgs).wrap {
          package = pkgs.kew;
          config = {sloth, ...}: let
            home = d: sloth.concat' sloth.homeDir "/${d}";
          in {
            dbus = {
              enable = true;
              policies = {
                "org.mpris.MediaPlayer2.kew" = "own"; # Media keys
                "org.freedesktop.Notifications" = "talk"; # Now playing
              };
            };
            bubblewrap = {
              bind.ro = map home [
                # XDG user dirs (desktop/user-dirs.nix)
                "Cyber"
                "Documents"
                "Downloads"
                "Notes"
                "Pictures"
                "Projects"
                "Videos"
              ];
              bind.rw = map home [".config/kew" ".local/state/kew" "Music"];
              env = {
                XDG_STATE_HOME = home ".local/state/kew"; # Otherwise kewstaterc lands directly in ~/.local/state
                TMPDIR = "/tmp"; # PID file
              };
              tmpfs = ["/tmp"];
              sockets = {
                pipewire = true;
                pulse = true;
              };
            };
          };
        };

        kewLauncher = pkgs.writeShellScript "kew-launcher" ''
          if [ -n "$1" ]; then
            exec ${kew}/bin/kew play "$1"
          else
            exec ${kew}/bin/kew
          fi
        '';
      in {
        packages = [
          kew
          (pkgs.makeDesktopItem {
            name = "kew";
            desktopName = "Music Player";
            exec = "${pkgs.kitty}/bin/kitty -o window_padding_width=0 ${kewLauncher} %f";
            comment = "Play music from the terminal";
            categories = ["Audio" "Music"];
            terminal = false;
            mimeTypes = mime.types.audio;
            keywords = ["lofi" "player" "music"];
          })
        ];

        xdg.mime-apps = mime.defaultFor "kew.desktop" mime.types.audio;

        persist.directories = [".config/kew" "Music"];
      })
    ];
  };
}
