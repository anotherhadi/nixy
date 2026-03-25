{
  inputs,
  pkgs,
  ...
}: {
  services = {
    nginx.virtualHosts."blog.local" = {
      root = "${inputs.blog.packages.${pkgs.system}.default}/share/blog";
      listen = [
        {
          addr = "127.0.0.1";
          port = 8758;
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
    cloudflared.tunnels."a1dfa315-7fc3-4a65-8c02-8387932c35c3".ingress."hadi.icu" = "http://127.0.0.1:8758";
    cloudflared.tunnels."a1dfa315-7fc3-4a65-8c02-8387932c35c3".ingress."www.hadi.icu" = "http://127.0.0.1:8758";
  };
}
