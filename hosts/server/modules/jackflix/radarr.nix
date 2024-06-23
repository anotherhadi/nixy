{
  users.users.radarr = {
    isSystemUser = true;
    home = "/var/lib/radarr-root";
  };

  services.radarr = {
    enable = true;
    openFirewall = true;
  };
}
