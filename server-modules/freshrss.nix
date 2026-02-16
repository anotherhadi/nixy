{
  pkgs,
  config,
  ...
}: let
  user = config.var.username;
in {
  sops.secrets = {
    freshrss = {
      owner = "freshrss";
      mode = "0600";
    };
  };

  services.freshrss = {
    enable = true;
    defaultUser = user;
    passwordFile = config.sops.secrets.freshrss.path;
    user = "freshrss";
    baseUrl = "https://rss.hadi.diy";
    webserver = "nginx";

    extensions = with pkgs.freshrss-extensions; [
      youtube
      title-wrap
      reading-time
    ];
  };

  services.cloudflared.tunnels."f7c8f777-a36c-4b9a-b6e3-6a112bd43e73".ingress."rss.hadi.diy" = "http://localhost:80";
}
