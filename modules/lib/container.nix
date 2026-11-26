# NixOS container helper for the server services (modules/server)
{lib, ...}: let
  nginxHardening = {config, ...}:
    lib.mkIf config.services.nginx.enable {
      services.nginx.serverTokens = false;
    };
in {
  flake.lib.mkContainer = osConfig: {
    name,
    hostIp,
    containerIp,
    internet ? false,
    lan ? [], # LAN subnets the container may reach, e.g. ["192.168.1.0/24"]
    externalInterface ? osConfig.nixy.server.networkInterface,
    bindMounts ? {},
    nixosConfig,
  }:
    assert lib.assertMsg (lib.stringLength "ve-${name}" <= 15)
    "mkContainer: interface name 've-${name}' is ${toString (lib.stringLength "ve-${name}")} chars, max is 15";
      {
        containers.${name} = {
          autoStart = true;
          privateNetwork = true;
          hostAddress = hostIp;
          localAddress = containerIp;
          inherit bindMounts;
          config = {...}: {
            imports = [
              nixosConfig
              nginxHardening
            ];
            networking.nameservers = lib.mkIf internet [
              "${hostIp}"
            ];
          };
        };
      }
      // (lib.optionalAttrs (internet || lan != []) (let
        # FORWARD rules for this container, in evaluation order:
        # allow return traffic, allow the given LAN subnets, block other private ranges,
        # then allow internet (or drop everything else).
        rules =
          ["-d ${containerIp} -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"]
          ++ map (subnet: "-s ${containerIp} -d ${subnet} -j ACCEPT") lan
          ++ map (range: "-s ${containerIp} -d ${range} -j DROP") ["10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16"]
          ++ [
            (
              if internet
              then "-s ${containerIp} -m conntrack --ctstate NEW -j ACCEPT"
              else "-s ${containerIp} -j DROP"
            )
          ];
      in {
        boot.kernel.sysctl."net.ipv4.ip_forward" = lib.mkDefault true;
        networking.nat = {
          enable = true;
          externalInterface = externalInterface;
          internalInterfaces = ["ve-${name}"];
        };
        # CONTAINER-FWD (defined by another module) blocks all forwarding by default.
        # Insert rules at the top of FORWARD (reversed, since each one is inserted at position 1).
        networking.firewall.extraCommands =
          lib.concatMapStrings (rule: "iptables -I FORWARD 1 ${rule}\n") (lib.reverseList rules);
        networking.firewall.extraStopCommands =
          lib.concatMapStrings (rule: "iptables -D FORWARD ${rule} 2>/dev/null || true\n") rules;
      }));
}
