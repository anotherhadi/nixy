# Monitui allows you to edit hyprland's monitor configuration
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox;
in {
  flake.modules.nixos.monitui = {
    imports = [aspects.hjem];

    # Bind sources must exist, otherwise the app writes into the sandbox's tmpfs and loses it
    systemd.user.tmpfiles.rules = [
      "d %h/.config/monitui 0700 - - -"
      "f %h/.config/hypr/monitors.conf 0600 - - -"
    ];

    hjem.extraModules = [
      ({pkgs, ...}: let
        # Sandboxed: no network, only its presets and monitors.conf.
        # Limited protection: the Hyprland socket (hyprctl) can run any command outside.
        monitui = (mkSandbox pkgs).wrap {
          package = pkgs.nur.repos.anotherhadi.monitui;
          config = {sloth, ...}: {
            dbus = {
              enable = true;
              policies."org.freedesktop.Notifications" = "talk"; # notify-send
            };
            bubblewrap = {
              bind.rw = [
                (sloth.concat' sloth.homeDir "/.config/monitui") # Presets
                (sloth.concat' sloth.homeDir "/.config/hypr/monitors.conf")
              ];
              bind.ro = [(sloth.concat' sloth.runtimeDir "/hypr")]; # hyprctl socket
            };
          };
        };
      in {
        packages = [
          monitui
          (pkgs.makeDesktopItem {
            name = "monitui";
            desktopName = "monitui";
            exec = "${pkgs.ghostty}/bin/ghostty +new-window -e ${monitui}/bin/monitui";
            comment = "Delightfully minimal TUI for wrangling Hyprland monitors";
            categories = ["Settings" "HardwareSettings"];
            terminal = false;
            keywords = ["hyprland" "monitor" "display" "screen" "resolution"];
          })
        ];
      })
    ];
  };
}
