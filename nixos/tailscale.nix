# Tailscale is a VPN service that makes it easy to connect your devices between each other.
{
  config,
  inputs,
  ...
}: let
  username = config.var.username;
in {
  security.sudo.extraRules = [
    {
      users = [username];
      # Allow running Tailscale commands without a password
      commands = [
        {
          command = "/etc/profiles/per-user/${username}/bin/tailscale";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/tailscale";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  environment.systemPackages = with inputs.nixpkgs-stable.legacyPackages.x86_64-linux; [
    tailscale
  ];

  services.tailscale = {
    enable = true;
    package = inputs.nixpkgs-stable.legacyPackages.x86_64-linux.tailscale;
    openFirewall = true;
  };

  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
    # required to connect to Tailscale exit nodes
    checkReversePath = "loose";
  };
}
