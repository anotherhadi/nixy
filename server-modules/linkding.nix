# Linkding is a self-hosted bookmark manager
{...}: let
  port = 9090;
in {
  virtualisation.oci-containers.containers.linkding = {
    autoStart = true;
    image = "sissbruecker/linkding@sha256:6d4fcc50bee8ee054ad2dfebbc41217f325398b907aff7ec011996c6a5ec17c9";
    volumes = ["/var/lib/linkding/data:/etc/linkding/data"];
    ports = ["${builtins.toString port}:${builtins.toString port}"];
  };

  # Ensure our mount point exists
  systemd.tmpfiles.settings."10-linkding" = {
    "/var/lib/linkding/data" = {
      d = {
        mode = "0755";
        user = "root";
        group = "root";
      };
    };
  };

  services.cloudflared.tunnels."f7c8f777-a36c-4b9a-b6e3-6a112bd43e73".ingress."linkding.hadi.diy" = "http://localhost:${toString port}";
}
