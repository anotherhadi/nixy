# Nextcloud is a self-hosted productivity platform that allows you to store and share files, manage calendars, contacts, and more.
{
  pkgs,
  config,
  ...
}: let
  domain = "cloud.hadi.diy";
  adminuser = "hadi";
in {
  services = {
    nginx.virtualHosts = {
      "${domain}" = {
        # DNS-01 challenge
        useACMEHost = "hadi.diy";
        forceSSL = true;
      };
    };
    nextcloud = {
      enable = true;
      hostName = domain;
      package = pkgs.nextcloud31;
      database.createLocally = true;
      configureRedis = true;
      maxUploadSize = "16G";
      https = true;
      autoUpdateApps.enable = true;
      settings = {
        trusted_domains = [domain];
        default_phone_region = "FR";
        overwriteprotocol = "https";
      };
      extraAppsEnable = true;
      # extraApps = with config.services.nextcloud.package.packages.apps; {
      # List of apps we want to install and are already packaged in
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
      # inherit calendar contacts notes onlyoffice tasks cookbook qownnotesapi;
      # inherit cookbook;
      # Custom app example.
      #        socialsharing_telegram = pkgs.fetchNextcloudApp rec {
      #          url =
      #            "https://github.com/nextcloud-releases/socialsharing/releases/download/v3.0.1/socialsharing_telegram-v3.0.1.tar.gz";
      #          license = "agpl3";
      #          sha256 = "sha256-8XyOslMmzxmX2QsVzYzIJKNw6rVWJ7uDhU1jaKJ0Q8k=";
      #        };
      # };
      config = {
        dbtype = "pgsql";
        adminuser = adminuser;
        adminpassFile = config.sops.secrets.nextcloud-pwd.path;
      };
      # Suggested by Nextcloud's health check.
      phpOptions."opcache.interned_strings_buffer" = "16";
    };
  };

  sops.secrets.nextcloud-pwd.path = "/etc/nextcloud/pwd.txt";
}
