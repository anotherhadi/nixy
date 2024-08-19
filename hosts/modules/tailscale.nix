{ config, ... }: { services.tailscale.enable = config.var.tailscale; }
