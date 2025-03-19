{ inputs, ... }: {
  sops = {
    age.keyFile = "/home/hadi/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      "example" = {
        owner = "hadi";
        path = "/etc/test";
      };
    };
  };
}
