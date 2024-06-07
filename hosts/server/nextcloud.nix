{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [ nextcloud29 ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    hostName = "localhost:8081";
    config.adminpassFile = "/etc/nextcloudpwd";
  };
}
