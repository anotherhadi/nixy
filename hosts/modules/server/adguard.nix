# Network-wide ads & trackers blocking DNS server
# Change your router primary DNS server to {this server IP} to make it network wide.
{
  services.adguardhome = {
    enable = true;
    host = "0.0.0.0";
    port = 3000;
    allowDHCP = true;
    openFirewall = true;
  };
  networking.firewall.allowedTCPPorts = [ 53 3000 ];
}
