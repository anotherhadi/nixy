{
  services.jellyfin = {
    enable = true;
    user = "jackflix";
    group = "jackflix";
    dataDir = "/home/jackflix/jellyfin/data";
    cacheDir = "/home/jackflix/jellyfin/cache";
    logDir = "/home/jackflix/jellyfin/log";
    configDir = "/home/jackflix/jellyfin/config";
    openFirewall = true;
  };
}
