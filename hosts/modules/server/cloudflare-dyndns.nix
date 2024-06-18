# CloudFlare Dynamic DNS client
{
    services.cloudflare-dyndns = {
        enable = true;
        ipv4 = true;
        domains = [ "cloud.anotherhadi.com" "vault.anotherhadi.com" "try.anotherhadi.com"];
        proxied = true;
        apiTokenFile = "/etc/cloudflare/apiToken";
    };
}