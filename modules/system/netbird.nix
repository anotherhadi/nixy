# NetBird client
# First login: netbird up --management-url https://netbird.domain.com
{
  flake.modules.nixos.netbird = {
    services.netbird.enable = true;

    networking.firewall.trustedInterfaces = ["wt0"];

    environment.persistence."/persist".directories = ["/var/lib/netbird"]; # Peer identity
  };
}
