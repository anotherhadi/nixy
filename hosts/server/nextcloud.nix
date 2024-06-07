{ pkgs, ... }: {
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    hostName = "localhost";
    config.adminpassFile = "/etc/nextcloudpwd";
  };
}
