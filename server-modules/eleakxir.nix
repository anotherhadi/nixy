{
  inputs,
  config,
  pkgs,
  ...
}: {
  services.eleakxir-backend = {
    enable = true;
    port = 8080;
    leakPath = "/mnt/ssd/leaks";
  };

  services.nginx = {
    virtualHosts."eleakxir.hadi.diy" = {
      useACMEHost = "hadi.diy";
      forceSSL = true;

      root = "${
        inputs.socme.packages.${pkgs.system}.eleakxir-frontend
      }/eleakxir-frontend";

      locations."/api/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.eleakxir-backend.port}/";
        recommendedProxySettings = true;
        extraConfig = ''
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
