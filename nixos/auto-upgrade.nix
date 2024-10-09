{ config, ... }:
let configDir = config.var.configDirectory;
in {
  system.autoUpgrade = {
    enable = config.var.autoUpgrade;
    dates = "04:00";
    flake = "${configDir}";
    flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
    allowReboot = false;
  };
}
