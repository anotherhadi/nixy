{ inputs, ... }: {
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    age.keyFile = "/home/hadi/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      "example" = {
        owner = "hadi";
        path = "/home/hadi/test";
      };
    };
  };

}
