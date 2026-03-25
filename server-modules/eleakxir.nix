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

  services.cloudflared.tunnels."a1dfa315-7fc3-4a65-8c02-8387932c35c3".ingress."eleakxir-back.hadi.icu" = "http://localhost:${toString config.services.eleakxir.port}";
}
