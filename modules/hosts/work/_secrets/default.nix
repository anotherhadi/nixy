# Those are my secrets, encrypted with sops
# You shouldn't import this file, unless you edit it
{config, ...}: let
  username = config.nixy.username;
  home = config.users.users.${username}.home;
in {
  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      ssh-config = {
        owner = username;
        mode = "0600";
        path = "${home}/.ssh/config";
      };
      netrc = {
        owner = username;
        mode = "0600";
        path = "${home}/.netrc";
      };
      ssh-github-key = {
        owner = username;
        mode = "0600";
        path = "${home}/.ssh/github";
      };
      ssh-gitlab-key = {
        owner = username;
        mode = "0600";
        path = "${home}/.ssh/gitlab";
      };
    };
  };
}
