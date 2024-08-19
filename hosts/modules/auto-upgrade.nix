{ config, ... }: {
  system.autoUpgrade = {
    enable = config.var.autoUpgrade;
    dates = "04:00";
    flake = "${config.var.configDirectory}";
    flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
    allowReboot = false;
  };
}
