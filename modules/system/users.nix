# Users configuration for NixOS
{
  flake.modules.nixos.users = {
    config,
    pkgs,
    ...
  }: let
    username = config.nixy.username;
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
      };
    };
  };
}
