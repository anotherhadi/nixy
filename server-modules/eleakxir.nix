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

  services.cloudflared.tunnels."f7c8f777-a36c-4b9a-b6e3-6a112bd43e73".ingress."eleakxir-back.hadi.diy" = "http://localhost:${toString config.services.eleakxir.port}";
}
