{
  inputs,
  pkgs,
  ...
}: {
  services = {
    nginx.virtualHosts."wall.local" = {
      root = "${inputs.awesome-wallpapers.packages.${pkgs.system}.default}/share/awesome-wallpapers";
      listen = [
        {
          addr = "127.0.0.1";
          port = 8759;
        }
      ];
      locations."/" = {
        tryFiles = "$uri $uri/ /index.html";
      };
      extraConfig = ''
        port_in_redirect off;
        absolute_redirect off;
      '';
    };
    cloudflared.tunnels."a1dfa315-7fc3-4a65-8c02-8387932c35c3".ingress."wallpapers.hadi.icu" = "http://127.0.0.1:8759";
  };
}
