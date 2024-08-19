{ config, pkgs, ... }: {
  users = {
    defaultUserShell = pkgs.zsh;
    users.${config.var.username} = {
      isNormalUser = true;
      description = "${config.var.username} account";
      extraGroups = [ "networkmanager" "wheel" ];
    };
  };
}
