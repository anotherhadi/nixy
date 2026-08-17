# Those are my secrets, encrypted with sops
# You shouldn't import this file, unless you edit it
{
  pkgs,
  config,
  ...
}: let
  username = config.var.username;
  home = "/home/${username}";
in {
  sops = {
    age.keyFile = "${home}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      ssh-config = {
        owner = username;
        mode = "0600";
        path = "${home}/.ssh/config";
      };
      ssh-github-key = {
        owner = username;
        mode = "0600";
        path = "${home}/.ssh/github";
      };
      anotherhadi-pgp-key = {
        owner = username;
        mode = "0600";
        path = "${home}/.ssh/anotherhadi-priv.asc";
      };
      ssh-jack-key = {
        owner = username;
        mode = "0600";
        path = "${home}/.ssh/jack";
      };
      signing-key = {
        owner = username;
        mode = "0600";
        path = "${home}/.ssh/key";
      };
      signing-pub-key = {
        owner = username;
        mode = "0600";
        path = "${home}/.ssh/key.pub";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
