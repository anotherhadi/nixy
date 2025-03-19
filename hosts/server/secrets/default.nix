{ inputs, ... }: {
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
      # cloudflare-dns-token = { path = "/etc/cloudflare/dnskey.txt"; };
    };
  };
}
