{config, ...}: {
  services.glance.settings.pages = [
    {
      name = "Server";
      hide-desktop-navigation = false;
      columns = [
        {
          size = "full";
          widgets = [
            {
              type = "server-stats";
              servers = [
                {
                  type = "local";
                  name = "Jack";
                }
              ];
            }
            {
              type = "group";
              widgets = [
                {
                  type = "monitor";
                  title = "Services";
                  cache = "1m";
                  sites = [
                    {
                      title = "Adguard";
                      url = "https://adguard.hadi.icu";
                      icon = "si:adguard";
                    }
                    {
                      title = "Mealie";
                      url = "https://mealie.hadi.icu";
                      icon = "si:mealie";
                    }
                    {
                      title = "Linkding";
                      url = "https://linkding.hadi.icu";
                      icon = "sh:linkding";
                    }
                    {
                      title = "Mazanoke";
                      url = "https://mazanoke.hadi.icu";
                      icon = "sh:mazanoke";
                    }
                    {
                      title = "Stirling PDF";
                      url = "https://pdf.hadi.icu";
                      icon = "sh:stirling-pdf";
                    }
                    {
                      title = "Default-creds";
                      url = "https://default-creds.hadi.icu";
                      icon = "si:passbolt";
                    }
                    {
                      title = "Blog";
                      url = "https://hadi.icu";
                      icon = "si:blogger";
                    }
                    {
                      title = "Cyberchef";
                      url = "https://cyberchef.hadi.icu";
                      icon = "si:codechef";
                    }
                  ];
                }
                {
                  type = "monitor";
                  title = "*arr";
                  cache = "1m";
                  sites = [
                    {
                      title = "Jellyfin";
                      url = "https://media.hadi.icu";
                      icon = "si:jellyfin";
                    }
                    {
                      title = "Jellyseerr";
                      url = "https://demandemedia.hadi.icu";
                      icon = "si:odysee";
                    }
                    {
                      title = "Radarr";
                      url = "https://radarr.hadi.icu";
                      icon = "si:radarr";
                    }
                    {
                      title = "Sonarr";
                      url = "https://sonarr.hadi.icu";
                      icon = "si:sonarr";
                    }
                    {
                      title = "Bazarr";
                      url = "https://bazarr.hadi.icu";
                      icon = "si:subtitleedit";
                    }
                    {
                      title = "Prowlarr";
                      url = "https://prowlarr.hadi.icu";
                      icon = "si:podcastindex";
                    }
                    {
                      title = "Transmission";
                      url = "https://transmission.hadi.icu";
                      icon = "si:transmission";
                    }
                  ];
                }
              ];
            }

            {
              type = "dns-stats";
              service = "adguard";
              url = "http://localhost:${toString config.services.adguardhome.port}";
              username = "hadi";
              password = "\${secret:adguard-pwd}";
            }

            {
              type = "bookmarks";
              groups = [
                {
                  title = "";
                  same-tab = true;
                  color = "245 50 64";
                  links = [
                    {
                      title = "Router";
                      url = "http://192.168.1.254/";
                    }
                    {
                      title = "Cloudflare";
                      url = "https://dash.cloudflare.com/";
                    }
                    {
                      title = "Cloudflare Zero Trust";
                      url = "https://one.dash.cloudflare.com/";
                    }
                    {
                      title = "Cloudflare Access";
                      url = "https://anotherhadi.cloudflareaccess.com";
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];
    }
  ];
}
