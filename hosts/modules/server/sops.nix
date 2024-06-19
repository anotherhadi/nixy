{

  sops = {
    age.keyFile = "/home/hadi/.config/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets/server.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      sshconfig = {
        path = "/home/hadi/.ssh/config";
        owner = "hadi";
      };
      github-key = {
        path = "/home/hadi/.ssh/github";
        owner = "hadi";
      };
      # nextcloud-adminpass = {
      #   path = "/etc/nextcloud/adminpassFile";
      #   owner = "nextcloud";
      #   group = "nextcloud";
      # };
      cloudflare-apitoken = {
        path = "/etc/cloudflare/apiToken";
        owner = "cloudflare-dyndns";
        group = "cloudflare-dyndns";
      };
      # tailscaled-authKey = {
      #   path = "/etc/tailscale/authKey";
      #   owner = "tailscaled";
      #   group = "tailscaled";
      # };
    };
  };
}
