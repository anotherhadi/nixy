# TickTick: todo app
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox;
in {
  flake.modules.nixos.ticktick = {
    imports = [aspects.hjem];

    # Bind sources must exist, otherwise the app writes into the sandbox's tmpfs and loses it
    systemd.user.tmpfiles.rules = ["d %h/.config/ticktick 0700 - - -"];

    hjem.extraModules = [
      ({pkgs, ...}: let
        # Sandboxed: network, only its own data
        ticktick = (mkSandbox pkgs).wrap {
          package = pkgs.ticktick;
          gui = true;
          config = {sloth, ...}: {
            app.binPath = "bin/ticktick"; # No meta.mainProgram
            dbus = {
              enable = true;
              policies."org.freedesktop.Notifications" = "talk"; # Reminders
            };
            bubblewrap = {
              network = true;
              bind.rw = [(sloth.concat' sloth.homeDir "/.config/ticktick")];
              sockets = {
                pipewire = true; # Reminder sound
                pulse = true;
              };
            };
          };
        };
      in {
        packages = [ticktick];

        persist.directories = [".config/ticktick"];
      })
    ];
  };
}
