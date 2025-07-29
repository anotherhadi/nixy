{
  inputs,
  config,
  pkgs,
  ...
}: {
  services.eleakxir-backend = {
    enable = true;
    port = 8080;
    leakPath = "/var/lib/eleakxir-backend/leaks";
    cachePath = "/var/lib/eleakxir-backend/cache";
  };

  services.nginx = {
    virtualHosts."eleakxir.hadi.diy" = {
      useACMEHost = "hadi.diy";
      forceSSL = true;

      root = "${
        inputs.eleakxir.packages.${pkgs.system}.frontend
      }/eleakxir-frontend";

      locations."/api/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.eleakxir-backend.port}/";
        extraConfig = ''
          # Crucial for SSE: Disable buffering
          proxy_buffering off;
          proxy_cache off;
          proxy_http_version 1.1;
          proxy_set_header Connection ""; # Required for HTTP/1.1 persistent connections
          proxy_read_timeout 36000s; # Long timeout, adjust as needed. SSE connections are long-lived.
          proxy_send_timeout 36000s; # Also important for sending data

          # Your existing rewrite rule (make sure this doesn't cause issues with SSE paths specifically)
          rewrite ^/api/(.*) /$1 break;
        '';
      };

      locations."/" = {
        extraConfig = ''
          try_files $uri $uri/ /index.html =404; # Fallback vers index.html pour les routes SPA
        '';
      };
    };
  };
}
