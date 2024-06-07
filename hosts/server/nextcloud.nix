{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [ nextcloud29 ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    hostName = "localhost";
    config.adminpassFile = "/etc/nextcloudpwd";
    settings = { port = 8080; };
  };
}
