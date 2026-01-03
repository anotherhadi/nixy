{
  config,
  pkgs,
  ...
}: {
  sops.secrets = {
    cloudflared-token = {
      mode = "0400";
    };
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "f7c8f777-a36c-4b9a-b6e3-6a112bd43e73" = {
        credentialsFile = config.sops.secrets."cloudflared-token".path;
        default = "http_status:404";
        ingress = {
          "media.hadi.diy" = "http://localhost:443";
          "demandemedia.hadi.diy" = "http://localhost:443";
          "ssh.hadi.diy" = "ssh://localhost:22";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    cloudflared
  ];

  # At the moment (2025), for support of browser rendering of the tunnels, this line is required:
  services.openssh.settings.Macs = [
    # Current defaults:
    "hmac-sha2-512-etm@openssh.com"
    "hmac-sha2-256-etm@openssh.com"
    "umac-128-etm@openssh.com"
    # Added:
    "hmac-sha2-256"
  ];
}
