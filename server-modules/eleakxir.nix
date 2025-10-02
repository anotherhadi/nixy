{
  config,
  inputs,
  pkgs,
  ...
}: {
  users.groups.eleakxir = {};
  users.users.hadi.extraGroups = ["eleakxir"];

  services.eleakxir = {
    enable = true;
    port = 9198;
    user = "eleakxir";
    group = "eleakxir";
    limit = 1000;
    folders = ["/var/lib/eleakxir/leaks/" "/mnt/data/clean-leak/"];
    debug = true;
  };

  environment.systemPackages = [
    inputs.eleakxir.packages.${pkgs.system}.leak-utils
  ];

  services.nginx.virtualHosts."eleakxir-back.hadi.diy" = {
    useACMEHost = "hadi.diy";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${
        toString config.services.eleakxir.port
      }";
    };
  };
}
