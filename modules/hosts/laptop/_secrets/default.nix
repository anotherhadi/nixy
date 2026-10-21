# Those are my secrets, encrypted with sops
# You shouldn't import this file, unless you edit it
# Only the host's own files live here, features declare theirs (modules/system/secrets.nix)
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
    };
  };
}
