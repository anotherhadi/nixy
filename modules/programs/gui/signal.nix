# Signal: encrypted messaging app
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox;
in {
  flake.modules.nixos.signal = {
    imports = [aspects.hjem];

    # Bind sources must exist, otherwise the app writes into the sandbox's tmpfs and loses it
    systemd.user.tmpfiles.rules = ["d %h/.config/Signal 0700 - - -"];

    hjem.extraModules = [
      ({pkgs, ...}: let
        # Sandboxed: network, its own data, ~/Documents and ~/Downloads (attachments)
        signal = (mkSandbox pkgs).wrap {
          package = pkgs.signal-desktop;
          gui = true;
          config = {sloth, ...}: {
            dbus = {
              enable = true;
              policies = {
                "org.freedesktop.Notifications" = "talk";
                "org.freedesktop.secrets" = "talk"; # Database key, stored in the gnome-keyring
              };
            };
            bubblewrap = {
              network = true;
              bind.rw = map (d: sloth.concat' sloth.homeDir "/${d}") [".config/Signal" "Documents" "Downloads"];
              sockets = {
                pipewire = true; # Calls, voice notes
                pulse = true;
              };
              # Webcam for video calls (Chromium opens the V4L2 devices directly)
              bind.dev = ["/dev/video0" "/dev/video1" "/dev/video2" "/dev/video3"];
              bind.ro = ["/sys/class/video4linux"];
            };
          };
        };
      in {
        packages = [signal];

        persist.directories = [".config/Signal"];
      })
    ];
  };
}
