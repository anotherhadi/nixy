{ config, ... }: {
  services.tailscale = {
    enable = config.var.tailscale;
    useRoutingFeatures = "both";
    authKeyFile = "/etc/tailscale/authKey";
    openFirewall = true;
    extraUpFlags = [ "--advertise-exit-node" ];
  };

  # Fix DNS & IPv6 bugs
  networking.nftables.enable = true;
  services.resolved.enable = true;
}
