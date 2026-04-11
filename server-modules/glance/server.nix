{
  domain,
  adguardUrl,
  ...
}: {
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
                      url = "https://adguard.${domain}";
                      icon = "si:adguard";
                    }
                    {
                      title = "Blog";
                      url = "https://${domain}";
                      icon = "si:blogger";
                    }
                    {
                      title = "Gitea";
                      url = "https://git.${domain}";
                      icon = "si:gitea";
                    }
                    {
                      title = "Mealie";
                      url = "https://mealie.${domain}";
                      icon = "si:mealie";
                    }
                    {
                      title = "Umami";
                      url = "https://umami.${domain}";
                      icon = "si:umami";
                    }
                    {
                      title = "Iknowyou";
                      url = "https://iknowyou.${domain}";
                      icon = "sh:iknowyou";
                    }
                    {
                      title = "Iknowyou Prod";
                      url = "https://iknowyou-prod.${domain}";
                      icon = "sh:iknowyou";
                    }
                    {
                      title = "Wallpapers";
                      url = "https://wallpapers.${domain}";
                      icon = "si:unsplash";
                    }
                    {
                      title = "Mazanoke";
                      url = "https://mazanoke.${domain}";
                      icon = "sh:mazanoke";
                    }
                    {
                      title = "Stirling PDF";
                      url = "https://pdf.${domain}";
                      icon = "sh:stirling-pdf";
                    }
                    {
                      title = "Default-creds";
                      url = "https://default-creds.${domain}";
                      icon = "si:passbolt";
                    }
                    {
                      title = "Cyberchef";
                      url = "https://cyberchef.${domain}";
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
                      url = "https://media.${domain}";
                      icon = "si:jellyfin";
                    }
                    {
                      title = "Jellyseerr";
                      url = "https://demandemedia.${domain}";
                      icon = "si:odysee";
                    }
                    {
                      title = "Radarr";
                      url = "https://radarr.${domain}";
                      icon = "si:radarr";
                    }
                    {
                      title = "Sonarr";
                      url = "https://sonarr.${domain}";
                      icon = "si:sonarr";
                    }
                    {
                      title = "Bazarr";
                      url = "https://bazarr.${domain}";
                      icon = "si:subtitleedit";
                    }
                    {
                      title = "Prowlarr";
                      url = "https://prowlarr.${domain}";
                      icon = "si:podcastindex";
                    }
                    {
                      title = "Transmission";
                      url = "https://transmission.${domain}";
                      icon = "si:transmission";
                    }
                  ];
                }
              ];
            }

            {
              type = "dns-stats";
              service = "adguard";
              url = adguardUrl;
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
