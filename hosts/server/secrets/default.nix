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
        path = "/home/hadi/.ssh/jack";
        mode = "0600";
      };
    };
  };
}
