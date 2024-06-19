# CloudFlare Dynamic DNS client
{
  services.cloudflare-dyndns = {
    enable = true;
    ipv4 = true;
    domains = [
      "cloud.anotherhadi.com"
      "vault.anotherhadi.com"
      "anotherhadi.com"
      "www.anotherhadi.com"
      "ntfy.anotherhadi.com"
    ];
    proxied = true;
    apiTokenFile = "/etc/cloudflare/apiToken";
  };
}
