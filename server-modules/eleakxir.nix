# Eleakxir is a search engine for leaked data.
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
    folders = ["/var/lib/eleakxir/leaks/" "/mnt/data/big-leaks/"];
    debug = true;
  };

  environment.systemPackages = [
    inputs.eleakxir.packages.${pkgs.stdenv.hostPlatform.system}.leak-utils
  ];

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."eleakxir-back.${config.var.domain}" = "http://localhost:${toString config.services.eleakxir.port}";
}
