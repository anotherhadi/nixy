{ config, ... }: {
  programs.nh = {
    enable = true;
    flake = config.var.configDirectory;
    clean.enable = config.var.autoGarbageCollector;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };
}
