{ pkgs, inputs, ... }: {
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  home.packages = with pkgs; [ sops age ];

  sops = {
    age.keyFile = "/home/hadi/.config/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets/server.yaml;
    secrets = {
      sshconfig = { path = "/home/hadi/.ssh/config"; };
      github-key = { path = "/home/hadi/.ssh/github"; };
      nextcloud-adminpass = { path = "/etc/nextcloud/adminpassFile"; };
      cloudflare-apitoken = { path = "/etc/cloudflare/apiToken"; };
      tailscaled-authKey = { path = "/etc/tailscale/authKey"; };
    };
  };

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
}
