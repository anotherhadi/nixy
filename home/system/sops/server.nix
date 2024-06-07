{ sops-nix, ... }: {
  imports = [ sops-nix.homeManagerModules.sops ];

  sops = {
    age.keyFile = "/home/hadi/.config/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets/secrets.yaml;
    secrets = {
      gts = { path = "/home/hadi/.ssh/github"; };
      sshconfigheaven = { path = "/home/hadi/.ssh/config"; };
      nextcloudpwd = { path = "/home/hadi/nextcloud/pwd"; };
    };
  };

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
}