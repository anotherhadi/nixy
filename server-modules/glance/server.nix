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
                      url = "https://adguard.hadi.diy";
                      icon = "si:adguard";
                    }
                    {
                      title = "Mealie";
                      url = "https://mealie.hadi.diy";
                      icon = "si:mealie";
                    }
                    {
                      title = "Linkding";
                      url = "https://linkding.hadi.diy";
                      icon = "sh:linkding";
                    }
                    {
                      title = "Mazanoke";
                      url = "https://mazanoke.hadi.diy";
                      icon = "sh:mazanoke";
                    }
                    {
                      title = "Stirling PDF";
                      url = "https://pdf.hadi.diy";
                      icon = "sh:stirling-pdf";
                    }
                    {
                      title = "Eleakxir";
                      url = "https://eleakxir.hadi.diy";
                      icon = "si:elixir";
                    }
                    {
                      title = "Cyberchef";
                      url = "https://cyberchef.hadi.diy";
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
                      url = "https://media.hadi.diy";
                      icon = "si:jellyfin";
                    }
                    {
                      title = "Jellyseerr";
                      url = "https://demandemedia.hadi.diy";
                      icon = "si:odysee";
                    }
                    {
                      title = "Radarr";
                      url = "https://radarr.hadi.diy";
                      icon = "si:radarr";
                    }
                    {
                      title = "Sonarr";
                      url = "https://sonarr.hadi.diy";
                      icon = "si:sonarr";
                    }
                    {
                      title = "Readarr";
                      url = "https://readarr.hadi.diy";
                      icon = "si:bookstack";
                    }
                    {
                      title = "Bazarr";
                      url = "https://bazarr.hadi.diy";
                      icon = "si:subtitleedit";
                    }
                    {
                      title = "Prowlarr";
                      url = "https://prowlarr.hadi.diy";
                      icon = "si:podcastindex";
                    }
                    {
                      title = "Transmission";
                      url = "https://transmission.hadi.diy";
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
                      url = "anotherhadi.cloudflareaccess.com";
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
