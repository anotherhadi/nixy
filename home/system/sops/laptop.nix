{ pkgs, sops-nix, ... }: {
  imports = [ sops-nix.homeManagerModules.sops ];

  home.packages = with pkgs; [ sops age ];

  sops = {
    age.keyFile = "/home/hadi/.config/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets/laptop.yaml;
    secrets = {
      sshconfig = { path = "/home/hadi/.ssh/config"; };
      github-key = { path = "/home/hadi/.ssh/github"; };
      gitlab-key = { path = "/home/hadi/.ssh/gitlab"; };
    };
  };

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
}
