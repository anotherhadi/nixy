# Firewall & fail2ban
{
    networking.firewall.enable = true;
    services.fail2ban = {
        enable = true;
        maxretry = 5;
    };
}