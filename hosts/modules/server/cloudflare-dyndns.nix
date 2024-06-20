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
      "test.anotherhadi.com"
      "jack.anotherhadi.com"
      "ntfy.anotherhadi.com"
      "home.anotherhadi.com"
      "kuma.anotherhadi.com"
    ];
    proxied = true;
    apiTokenFile = "/etc/cloudflare/apiToken";
  };
}
