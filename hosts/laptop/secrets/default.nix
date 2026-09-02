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
      personal-email = {
        owner = username;
      };
      personal-email-passwd = {
        owner = username;
      };
      seznam-email = {
        owner = username;
      };
      seznam-email-passwd = {
        owner = username;
      };
      work-email = {
        owner = username;
      };
      work-email-passwd = {
        owner = username;
      };
      discord-token = {
        owner = username;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
