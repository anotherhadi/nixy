{
  services.radarr = {
    enable = true;
    user = "jackflix";
    group = "jackflix";
    dataDir = "/home/jackflix/radarr";
    openFirewall = true;
  };
}
