# Network-wide ads & trackers blocking DNS server
# Change your router primary DNS server to {this server IP} to make it network wide.
{
  services.adguardhome = {
    enable = false;
    host = "0.0.0.0";
    port = 3000;
  };
  networking.firewall.allowedTCPPorts = [ 53 3000 ];
}
