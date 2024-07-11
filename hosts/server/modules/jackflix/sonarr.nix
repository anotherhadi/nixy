{
  services.sonarr = {
    enable = true;
    user = "jackflix";
    group = "jackflix";
    dataDir = "/home/jackflix/sonarr";
    openFirewall = true;
  };
}
