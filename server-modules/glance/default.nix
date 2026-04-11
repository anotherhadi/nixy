{ config, lib, ... }:
let
  inherit (import ../mk-container.nix { inherit lib config; }) mkContainer;
  domain = config.var.domain;
  hostIp = "10.233.12.1";

  # Convert 6-char hex color to "H S L" string for glance (integers, no % sign)
  hexToGlanceHsl = hex:
    let
      h = lib.toLower hex;
      d = c:
        if c == "a" then 10 else if c == "b" then 11 else if c == "c" then 12
        else if c == "d" then 13 else if c == "e" then 14 else if c == "f" then 15
        else lib.toInt c;
      byte = pos: d (builtins.substring pos 1 h) * 16 + d (builtins.substring (pos + 1) 1 h);
      ri = byte 0; gi = byte 2; bi = byte 4;
      r = ri * 1.0 / 255.0;
      g = gi * 1.0 / 255.0;
      b = bi * 1.0 / 255.0;
      mx = if r >= g && r >= b then "r" else if g >= b then "g" else "b";
      mn = if r <= g && r <= b then "r" else if g <= b then "g" else "b";
      cmax = if mx == "r" then r else if mx == "g" then g else b;
      cmin = if mn == "r" then r else if mn == "g" then g else b;
      delta = cmax - cmin;
      l = (cmax + cmin) / 2.0;
      s = if delta < 0.0001 then 0.0
          else if l <= 0.5 then delta / (cmax + cmin)
          else delta / (2.0 - cmax - cmin);
      hue =
        if delta < 0.0001 then 0.0
        else if mx == "r" then let raw = 60.0 * (g - b) / delta; in if raw < 0.0 then raw + 360.0 else raw
        else if mx == "g" then 60.0 * ((b - r) / delta + 2.0)
        else 60.0 * ((r - g) / delta + 4.0);
    in "${toString (builtins.floor (hue + 0.5))} ${toString (builtins.floor (s * 100.0 + 0.5))} ${toString (builtins.floor (l * 100.0 + 0.5))}";

  c = config.stylix.base16Scheme;
in
{
  # 0444 so the glance user inside the container can read the bind-mounted file
  sops.secrets.adguard-pwd.mode = "0444";

  imports = [
    (mkContainer {
      name = "glance";
      hostIp = hostIp;
      containerIp = "10.233.12.2";
      internet = true;
      bindMounts."/run/secrets/adguard-pwd" = {
        hostPath = config.sops.secrets.adguard-pwd.path;
        isReadOnly = true;
      };
      nixosConfig = { lib, ... }: {
        _module.args.domain = domain;
        _module.args.adguardUrl = "http://${hostIp}:3000";
        imports = [ ./home.nix ./server.nix ];

        services.glance = {
          enable = true;
          settings = {
            server = {
              port = 5678;
              host = "127.0.0.1";
            };
            theme = {
              light = false;
              background-color = hexToGlanceHsl c.base00; # background
              primary-color    = hexToGlanceHsl c.base0D; # accent (iris/purple)
              positive-color   = hexToGlanceHsl c.base0B; # positive (pine/teal)
              negative-color   = hexToGlanceHsl c.base08; # negative (love/rose)
            };
          };
        };

        services.nginx = {
          enable = true;
          appendHttpConfig = ''
            proxy_cache_path /var/cache/nginx/glance levels=1:2 keys_zone=glance:1m inactive=30m max_size=100m;
          '';
          virtualHosts."glance" = {
            listen = [{ addr = "0.0.0.0"; port = 8080; }];
            locations."/" = {
              proxyPass = "http://127.0.0.1:5678";
              extraConfig = ''
                proxy_cache glance;
                proxy_cache_valid 200 30m;
                proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
                add_header X-Cache-Status $upstream_cache_status;
              '';
            };
          };
        };

        networking.firewall.allowedTCPPorts = [ 8080 ];
        system.stateVersion = "24.05";
      };
    })
  ];

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."home.${domain}" = "http://10.233.12.2:8080";
}
