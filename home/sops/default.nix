{ sops-nix, config, ... }: {
  imports = [ sops-nix.homeManagerModules.sops ];

  sops = {
    age.keyFile = "/home/hadi/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    secrets = {
      sshconfig = { path = "/home/hadi/.ssh/config"; };
      oxk = { path = "/home/hadi/.ssh/oxserver"; };
      gk = { path = "/home/hadi/.ssh/github"; };
      glk = { path = "/home/hadi/.ssh/gitlab"; };
    };
  };

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
}
