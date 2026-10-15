{
  pkgs,
  config,
  ...
}: let
  username = config.nixy.username;
  home = config.users.users.${username}.home;
in {
  sops = {
    age.keyFile = "${home}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      sshconfig = {
        owner = username;
        path = "${home}/.ssh/config";
        mode = "0600";
      };
      ssh-github-key = {
        owner = username;
        path = "${home}/.ssh/github";
        mode = "0600";
      };
      signing-key = {
        owner = username;
        path = "${home}/.ssh/key";
        mode = "0600";
      };
      signing-pub-key = {
        owner = username;
        path = "${home}/.ssh/key.pub";
        mode = "0600";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
