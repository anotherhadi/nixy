{config, ...}: {
  services.glance.settings.pages = [
    {
      name = "Home";
      hide-desktop-navigation = false;
      columns = [
        {
          size = "small";
          widgets = [
            {
              type = "clock";
              hour-format = "24h";
            }
            {
              type = "weather";
              location = "Paris, France";
            }
            {
              type = "markets";
              markets = [
                {
                  symbol = "BTC-USD";
                  name = "Bitcoin";
                  chart-link = "https://www.tradingview.com/chart/?symbol=INDEX:BTCUSD";
                }
                {
                  symbol = "SOL-USD";
                  name = "Solana";
                  chart-link = "https://www.tradingview.com/chart/?symbol=INDEX:SOLUSD";
                }
                {
                  symbol = "ETH-USD";
                  name = "Ethereum";
                  chart-link = "https://www.tradingview.com/chart/?symbol=INDEX:ETHUSD";
                }
              ];
            }
          ];
        }
        {
          size = "full";
          widgets = [
            {
              type = "search";
              search-engine = "startpage";
            }
            {
              type = "group";
              widgets = [
                {
                  type = "bookmarks";
                  title = "Bookmarks";
                  groups = [
                    {
                      title = "";
                      same-tab = true;
                      color = "245 50 64";
                      links = [
                        {
                          title = "Linkding";
                          url = "https://linkding.hadi.diy";
                        }
                        {
                          title = "Mail";
                          url = "https://mail.proton.me";
                        }
                        {
                          title = "Drive";
                          url = "https://drive.proton.me";
                        }
                        {
                          title = "Lumo";
                          url = "https://lumo.proton.me";
                        }
                        {
                          title = "Gemini";
                          url = "https://gemini.google.com";
                        }
                        {
                          title = "Calendar";
                          url = "https://calendar.proton.me";
                        }
                      ];
                    }
                    {
                      title = "Tools";
                      same-tab = true;
                      color = "245 50 64";
                      links = [
                        {
                          title = "Excalidraw";
                          url = "https://excalidraw.com";
                        }
                        {
                          title = "Cobalt (downloader)";
                          url = "https://cobalt.meowing.de";
                        }
                        {
                          title = "Mazanoke (image downgrading)";
                          url = "https://mazanoke.hadi.diy";
                        }
                        {
                          title = "Stirling PDF";
                          url = "https://pdf.hadi.diy";
                        }
                        {
                          title = "Vert (file converter)";
                          url = "https://vert.sh";
                        }
                        {
                          title = "Markdown to pdf";
                          url = "https://md2file.com";
                        }
                      ];
                    }
                    {
                      title = "Social";
                      same-tab = true;
                      color = "245 50 64";
                      links = [
                        {
                          title = "X";
                          url = "https://x.com";
                        }
                        {
                          title = "Bsky";
                          url = "https://bsky.app";
                        }
                        {
                          title = "Reddit";
                          url = "https://reddit.com";
                        }
                        {
                          title = "Maps";
                          url = "https://maps.apple.com";
                        }
                        {
                          title = "Youtube";
                          url = "https://youtube.com";
                        }
                        {
                          title = "Github";
                          url = "https://github.com";
                        }
                      ];
                    }
                    {
                      title = "Other";
                      same-tab = true;
                      color = "245 50 64";
                      links = [
                        {
                          title = "Startpage config";
                          url = "https://www.startpage.com/do/mypage.pl?prfe=45d331deb05471d659dba933e7400df51d952bb103da6f6125c0e769a6be1d65610456a479f495ceeee7e97311cf227d7c1bb198de0ceeb193d8cddf9c455c19a409cc35c3e3f542ee27bd7cecd3";
                        }
                        {
                          title = "Hyprland Wiki";
                          url = "https://wiki.hypr.land";
                        }
                        {
                          title = "Search NixOS";
                          url = "https://mynixos.com";
                        }
                        {
                          title = "Nixpkgs";
                          url = "https://github.com/NixOS/nixpkgs";
                        }
                      ];
                    }
                  ];
                }
                {
                  type = "bookmarks";
                  title = "Infosec";
                  groups = [
                    {
                      title = "";
                      same-tab = true;
                      color = "245 50 64";
                      links = [
                        {
                          title = "Nix 4 Cyber";
                          url = "https://n4c.hadi.diy";
                        }
                        {
                          title = "Cyberchef";
                          url = "https://cyberchef.hadi.diy";
                        }
                        {
                          title = "TryHackMe";
                          url = "https://tryhackme.com";
                        }
                        {
                          title = "Root-Me";
                          url = "https://root-me.org";
                        }
                        {
                          title = "Exploit-DB";
                          url = "https://exploit-db.com";
                        }
                        {
                          title = "Crack Station";
                          url = "https://crackstation.net";
                        }
                        {
                          title = "Osint Tracker";
                          url = "https://app.osintracker.com";
                        }
                      ];
                    }
                  ];
                }
              ];
            }
            {
              type = "hacker-news";
              limit = 15;
              collapse-after = 5;
            }
          ];
        }
      ];
    }
  ];
}
