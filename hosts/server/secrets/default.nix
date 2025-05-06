{ pkgs, ... }: {
  sops = {
    age.keyFile = "/home/hadi/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      sshconfig = {
        owner = "hadi";
        path = "/home/hadi/.ssh/config";
        mode = "0600";
      };
      github-key = {
        owner = "hadi";
        path = "/home/hadi/.ssh/github";
        mode = "0600";
      };
      signing-key = {
        owner = "hadi";
        path = "/home/hadi/.ssh/key";
        mode = "0600";
      };
      signing-pub-key = {
        owner = "hadi";
        path = "/home/hadi/.ssh/key.pub";
        mode = "0600";
      };
      cloudflare-dns-token = { path = "/etc/cloudflare/dnskey.txt"; };
      nextcloud-pwd = { path = "/etc/nextcloud/pwd.txt"; };
      adguard-pwd = { };
      hoarder = { };
      recyclarr = {
        owner = "recyclarr";
        mode = "0777";
      };
      wireguard-pia = { };
    };
  };

  environment.systemPackages = with pkgs; [ sops age ];
}
