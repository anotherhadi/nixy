# Users configuration for NixOS
{
  config,
  pkgs,
  ...
}: let
  username = config.var.username;
in {
  programs.zsh.enable = true;
  users = {
    defaultUserShell = pkgs.zsh;

    users.${username} = {
      isNormalUser = true;
      description = "${username} account";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      # CHANGEME: Set your password with: mkpasswd -m sha-512
      # Or use initialPassword for first boot, then change it
      initialPassword = "nixos";
    };
  };
}
