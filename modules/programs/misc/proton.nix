# Proton tools
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mkSandbox;
in {
  flake.modules.nixos.proton = {
    imports = [aspects.hjem];

    systemd.user.tmpfiles.rules = [
      "d %h/.config/Proton 0700 - - -"
      "d %h/.cache/Proton 0700 - - -"
      "d %h/.config/proton-vpn-tui 0700 - - -"
    ];

    hjem.extraModules = [
      ({
        pkgs,
        scripts,
        ...
      }: let
        # Sandboxed: network, NetworkManager, the keyring for the session, and only Proton's own files.
        # The TUI drives protonvpn and nmcli, which run sandboxed inside it.
        sandbox = package:
          (mkSandbox pkgs).wrap {
            inherit package;
            config = {sloth, ...}: {
              dbus = {
                enable = true;
                policies."org.freedesktop.secrets" = "talk"; # Session, stored in the gnome-keyring
              };
              bubblewrap = {
                network = true;
                bind.rw = map (d: sloth.concat' sloth.homeDir "/${d}") [
                  ".config/Proton"
                  ".cache/Proton"
                  ".config/proton-vpn-tui"
                ];
                bind.ro = ["/run/dbus/system_bus_socket"]; # NetworkManager
                tmpfs = ["/tmp"];
              };
            };
          };

        protonvpn = sandbox pkgs.proton-vpn-cli;
        proton-vpn-tui = sandbox pkgs.nur.repos.anotherhadi.proton-vpn-tui;
      in {
        packages = [
          proton-vpn-tui
          protonvpn
          (pkgs.makeDesktopItem {
            name = "proton-vpn-tui";
            desktopName = "Proton VPN";
            exec = "${scripts.term}/bin/term ${proton-vpn-tui}/bin/proton-vpn-tui";
            comment = "Connect to Proton VPN from the terminal";
            categories = ["Network"];
            terminal = false;
            keywords = ["vpn" "proton" "protonvpn" "network"];
          })
        ];
      })
    ];
  };
}
