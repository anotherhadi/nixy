{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    authKeyFile = "/etc/tailscale/authKey";
    openFirewall = true;
    extraUpFlags = [ "--advertise-exit-node" ];
  };

  # Fix DNS & IPv6 bugs
  networking.nftables.enable = true;
  services.resolved.enable = true;
}
