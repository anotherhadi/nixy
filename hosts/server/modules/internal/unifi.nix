# unifi controller service
{
  services.unifi = {
    enable = true;
    openFirewall = true; # 8443(webui) and other port use by AP
  };
}
