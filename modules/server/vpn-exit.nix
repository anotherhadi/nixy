# NetBird exit nodes that send traffic out through Proton VPN (WireGuard), one container each
{config, ...}: let
  inherit (config.flake.lib) mkContainer;

  table = "51820";

  # Proton servers (peer of each generated config), the PrivateKey is in sops as `secret`
  exits = {
    vpn-exit = { # Switzerland
      subnet = 18; # 10.233.<subnet>.0/24
      secret = "wireguard-private-key-ch";
      publicKey = "36G8+pInNcPK9F1TpHglWs9Pk5uJOY9o8SCNrCBgvHE=";
      endpoint = "89.222.96.158:51820";
      address = "10.2.0.2/32";
    };
    vpn-exit-fr = {
      subnet = 19;
      secret = "wireguard-private-key-fr";
      publicKey = "73brgycS3YnRLfa2pZCHiXjIDJv6L091uSEDzFW88UI="; # FR#390
      endpoint = "79.127.169.1:51820";
      address = "10.2.0.2/32";
    };
  };
in {
  flake.modules.nixos.vpn-exit = {
    config,
    lib,
    ...
  }: let
    mkExit = name: exit:
      mkContainer config {
        inherit name;
        hostIp = "10.233.${toString exit.subnet}.1";
        containerIp = "10.233.${toString exit.subnet}.2";
        internet = true;
        bindMounts = {
          "/run/secrets/wireguard".hostPath = config.sops.secrets.${exit.secret}.path;
          "/dev/net/tun" = {
            hostPath = "/dev/net/tun";
            isReadOnly = false;
          };
        };
        nixosConfig = {pkgs, ...}: {
          services.netbird = {
            enable = true;
            useRoutingFeatures = "server";
          };

          networking.wireguard.interfaces.wg-proton = {
            ips = [exit.address];
            privateKeyFile = "/run/secrets/wireguard";
            allowedIPsAsRoutes = false;
            peers = [
              {
                inherit (exit) publicKey endpoint;
                allowedIPs = ["0.0.0.0/0"];
                persistentKeepalive = 25;
              }
            ];
            postSetup = ''
              ${pkgs.iproute2}/bin/ip route replace default dev wg-proton table ${table}
            '';
            postShutdown = ''
              ${pkgs.iproute2}/bin/ip route flush table ${table} || true
            '';
          };

          systemd.services.vpn-exit-rules = {
            wantedBy = ["multi-user.target"];
            before = ["netbird.service" "wireguard-wg-proton.service"];
            path = [pkgs.iproute2];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              ip rule del iif wt0 lookup ${table} priority 100 2>/dev/null || true
              ip rule del iif wt0 unreachable priority 101 2>/dev/null || true
              ip rule add iif wt0 lookup ${table} priority 100
              ip rule add iif wt0 unreachable priority 101
            '';
          };

          networking.firewall = {
            checkReversePath = "loose";
            extraCommands = ''
              iptables -I FORWARD 1 -i wt0 ! -o wg-proton -j DROP
              ip6tables -I FORWARD 1 -i wt0 -j DROP
              iptables -t nat -A POSTROUTING -o wg-proton -j MASQUERADE
              iptables -t mangle -A FORWARD -o wg-proton -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
            '';
            extraStopCommands = ''
              iptables -D FORWARD -i wt0 ! -o wg-proton -j DROP 2>/dev/null || true
              ip6tables -D FORWARD -i wt0 -j DROP 2>/dev/null || true
              iptables -t nat -D POSTROUTING -o wg-proton -j MASQUERADE 2>/dev/null || true
              iptables -t mangle -D FORWARD -o wg-proton -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu 2>/dev/null || true
            '';
          };

          system.stateVersion = "26.05";
        };
      };
  in {
    imports = lib.mapAttrsToList mkExit exits;

    # Bind-mounted file: restart the container so it sees a new key
    sops.secrets = lib.mapAttrs' (name: exit:
      lib.nameValuePair exit.secret {restartUnits = ["container@${name}.service"];})
    exits;

    containers = lib.mapAttrs (_: _: {
      allowedDevices = [
        {
          node = "/dev/net/tun";
          modifier = "rwm";
        }
      ];
    })
    exits;

    # The containers can't load kernel modules themselves
    boot.kernelModules = ["wireguard"];
  };
}
