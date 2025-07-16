{pkgs, ...}: {
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
    };
  };

  environment.systemPackages = with pkgs; [sops age];
}
