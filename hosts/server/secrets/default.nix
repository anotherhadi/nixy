{

  sops = {
    age.keyFile = "/home/hadi/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
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
      nextcloud-adminpass = {
        mode = "0444";
        path = "/etc/nextcloud/adminpassFile";
      };
      cloudflare-apitoken = {
        mode = "0444";
        path = "/etc/cloudflare/apiToken";
      };
      tailscaled-authKey = {
        mode = "0444";
        path = "/etc/tailscale/authKey";
      };
      transmission-script = {
        mode = "0755";
        path = "/home/jackflix/transmission-script.sh";
      };
      pia-wg = {
        mode = "0755";
        path = "/data/.secret/wg.conf";
      };
    };
  };
}
