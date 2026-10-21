# Only the host's own files live here, features declare theirs (modules/system/secrets.nix)
{config, ...}: let
  username = config.nixy.username;
  home = config.users.users.${username}.home;
in {
  sops = {
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
    };
  };
}
