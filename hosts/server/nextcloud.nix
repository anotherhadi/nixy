{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [ nextcloud29 ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    hostName = "localhost";
    config.adminpassFile = "/etc/nextcloudpwd";
    settings = { overwritehost = "localhost:8080"; };
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
