# Web-based graphical interface for servers
{
  services.cockpit = {
    enable = true;
    port = 3009;
    openFirewall = true;
  };
}
