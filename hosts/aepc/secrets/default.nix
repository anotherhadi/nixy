# Those are my secrets, encrypted with sops
# You shouldn't import this file, unless you edit it
{ pkgs, inputs, ... }: {
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    age.keyFile = "/home/ilbumi/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      sshconfig = { path = "/home/ilbumi/.ssh/config"; };
      github-key = { path = "/home/ilbumi/.ssh/github"; };
      gitlab-key = { path = "/home/ilbumi/.ssh/gitlab"; };
      home-key = { path = "/home/ilbumi/.ssh/home"; };
      signing-key = { path = "/home/ilbumi/.ssh/key"; };
      signing-pub-key = { path = "/home/ilbumi/.ssh/key.pub"; };
    };
  };

  home.file.".config/nixos/.sops.yaml".text = ''
    keys:
      - &primary age12yvtj49pfh3fqzqflscm0ek4yzrjhr6cqhn7x89gdxnlykq0xudq5c7334
    creation_rules:
      - path_regex: hosts/laptop/secrets/secrets.yaml$
        key_groups:
          - age:
            - *primary
      - path_regex: hosts/server/secrets/secrets.yaml$
        key_groups:
          - age:
            - *primary
  '';

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
  home.packages = with pkgs; [ sops age ];

  wayland.windowManager.hyprland.settings.exec-once =
    [ "systemctl --user start sops-nix" ];
}
