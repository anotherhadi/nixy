{
  services.jellyfin = {
    enable = true;
    user = "jackflix";
    group = "jackflix";
    dataDir = "/home/jackflix/jellyfin";
    openFirewall = true;
  };
}
