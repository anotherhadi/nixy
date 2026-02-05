# Those are my secrets, encrypted with sops
# You shouldn't import this file, unless you edit it
{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.sops-nix.homeManagerModules.sops];

  sops = {
    age.keyFile = "/home/hadrien/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      ssh-config = {path = "/home/hadrien/.ssh/config";};
      github-key = {path = "/home/hadrien/.ssh/github";};
    };
  };

  home.file.".config/nixos/.sops.yaml".text = ''
    keys:
      - &primary age12yvtj49pfh3fqzqflscm0ek4yzrjhr6cqhn7x89gdxnlykq0xudq5c7334
      - &work age1c8pawdsxptfslgrz2c56s39mrtnjzc5mm3hfzgr2wdwu2v6vfsdsupjsq6
    creation_rules:
      - path_regex: hosts/laptop/secrets/secrets.yaml$
        key_groups:
          - age:
            - *primary
      - path_regex: hosts/server/secrets/secrets.yaml$
        key_groups:
          - age:
            - *primary
      - path_regex: hosts/pph/secrets/secrets.yaml$
        key_groups:
          - age:
            - *work
  '';

  systemd.user.services.mbsync.Unit.After = ["sops-nix.service"];
  home.packages = with pkgs; [sops age];

  wayland.windowManager.hyprland.settings.exec-once = ["systemctl --user start sops-nix"];
}
