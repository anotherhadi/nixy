# Network-wide ads & trackers blocking DNS server
# Change your router primary DNS server to {this server IP} to make it network wide.
{
  services.adguardhome = {
    enable = true;
    host = "0.0.0.0";
    port = 3001;
    openFirewall = true; # Open port 53(dns) & 3000(webui)
  };
  networking.firewall.allowedTCPPorts = [ 53 ];
}
