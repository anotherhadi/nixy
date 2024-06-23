{
  users.users.radarr = {
    isSystemUser = true;
    home = "/var/lib/radarr";
  };

  services.radarr = {
    enable = true;
    openFirewall = true;
  };
}
