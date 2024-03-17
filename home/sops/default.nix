{ sops-nix, config, ... }: {
  imports = [ sops-nix.homeManagerModules.sops ];

  sops = {
    age.keyFile = "/home/hadi/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    secrets = { sshconfig = { path = "/home/hadi/.ssh/config"; }; };
  };

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];

  # Make home-manager crash on boot, dafuk ?
  #  home.activation.setupEtc = config.lib.dag.entryAfter [ "writeBoundary" ] ''
  #    /run/current-system/sw/bin/systemctl start --user sops-nix
  #  '';
}
