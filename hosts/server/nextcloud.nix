{ pkgs, ... }: {
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    hostName = "localhost";
    config.adminpassFile = "/home/hadi/nextcloud/pwd";
  };
}
