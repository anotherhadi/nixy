# Cloudflared tunnel configuration for NixOS
# It allows exposing services securely via Cloudflare Tunnel
{
  config,
  pkgs,
  ...
}: {
  sops.secrets.cloudflared-token.mode = "0400";

  # To setup cloudflared, run:
  # - `cloudflared tunnel login`
  # - `cloudflared tunnel create YourTunnelName`
  #
  # This will create a credentials file & give you the tunnel ID to use below.
  services.cloudflared = {
    enable = true;
    tunnels."a1dfa315-7fc3-4a65-8c02-8387932c35c3" = {
      credentialsFile = config.sops.secrets."cloudflared-token".path;
      default = "http_status:404";
    };
  };

  environment.systemPackages = with pkgs; [
    cloudflared
  ];

  systemd.services."cloudflared-tunnel-a1dfa315-7fc3-4a65-8c02-8387932c35c3" = {
    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];
    wants = ["network-online.target"];
  };

  # At the moment (2025), for support of browser rendering of the tunnels, this line is required:
  services.openssh.settings.Macs = [
    "hmac-sha2-256"
  ];
}
