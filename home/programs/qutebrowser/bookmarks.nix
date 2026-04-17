{
  config,
  lib,
  pkgs,
  ...
}: let
  bookmarkList = [
    {
      name = "Proton Mail";
      url = "https://mail.proton.me";
    }
    {
      name = "Proton Drive";
      url = "https://drive.proton.me";
    }
    {
      name = "Proton Lumo";
      url = "https://lumo.proton.me";
    }
    {
      name = "Proton Calendar";
      url = "https://calendar.proton.me";
    }
    {
      name = "Tools";
      bookmarks = [
        {
          name = "tldr";
          url = "https://tldr.inbrowser.app/";
        }
        {
          name = "Excalidraw";
          url = "https://excalidraw.com";
        }
        {
          name = "Cobalt (downloader)";
          url = "https://cobalt.meowing.de";
        }
        {
          name = "Mazanoke (image)";
          url = "https://mazanoke.hadi.icu";
        }
        {
          name = "Stirling PDF";
          url = "https://pdf.hadi.icu";
        }
        {
          name = "Vert";
          url = "https://vert.sh";
        }
        {
          name = "Markdown to PDF";
          url = "https://md2file.com";
        }
        {
          name = "Image to Vector";
          url = "https://www.vectorcascade.com/";
        }
        {
          name = "PrivateBin";
          url = "https://privatebin.net";
        }
      ];
    }
    {
      name = "Social";
      bookmarks = [
        {
          name = "Bluesky";
          url = "https://bsky.app";
        }
        {
          name = "Reddit";
          url = "https://reddit.com";
        }
        {
          name = "Youtube";
          url = "https://youtube.com";
        }
        {
          name = "Instagram";
          url = "https://instagram.com";
        }
        {
          name = "Github";
          url = "https://github.com";
        }
        {
          name = "Discord";
          url = "https://discord.com/channels/@me/";
        }
      ];
    }
    {
      name = "Other";
      bookmarks = [
        {
          name = "Startpage Config";
          url = "https://www.startpage.com/do/mypage.pl?prfe=45d331deb05471d659dba933e7400df51d952bb103da6f6125c0e769a6be1d65610456a479f495ceeee7e97311cf227d7c1bb198de0ceeb193d8cddf9c455c19a409cc35c3e3f542ee27bd7cecd3";
        }
        {
          name = "Hyprland Wiki";
          url = "https://wiki.hypr.land";
        }
        {
          name = "MyNixOS";
          url = "https://mynixos.com";
        }
        {
          name = "Nixpkgs";
          url = "https://github.com/NixOS/nixpkgs";
        }
        {
          name = "Claude";
          url = "https://claude.ai";
        }
        {
          name = "Gemini";
          url = "https://gemini.google.com";
        }
        {
          name = "Medium";
          url = "https://medium.com";
        }
        {
          name = "Maps";
          url = "https://maps.apple.com";
        }
        {
          name = "Amazon";
          url = "https://amazon.fr";
        }
      ];
    }
    {
      name = "Infosec";
      bookmarks = [
        {
          name = "Nix 4 Cyber";
          url = "https://n4c.hadi.icu";
        }
        {
          name = "Cyberchef";
          url = "https://cyberchef.hadi.icu";
        }
        {
          name = "TryHackMe";
          url = "https://tryhackme.com";
        }
        {
          name = "Root-Me";
          url = "https://root-me.org";
        }
        {
          name = "Exploit-DB";
          url = "https://exploit-db.com";
        }
        {
          name = "Crack Station";
          url = "https://crackstation.net";
        }
        {
          name = "Osint Tracker";
          url = "https://app.osintracker.com";
        }
      ];
    }
  ];

  c = config.lib.stylix.colors;

  stripProtocol = url:
    lib.removePrefix "https://" (lib.removePrefix "http://" url);

  mkCard = item: ''
    <a href="${item.url}" class="card">
      <div class="favicon-wrapper">
        <span class="favicon-fallback">${builtins.substring 0 1 item.name}</span>
      </div>
      <div class="card-info">
        <span class="card-name">${item.name}</span>
        <span class="card-url">${stripProtocol item.url}</span>
      </div>
    </a>'';

  # Group consecutive root items so they share the same .cards grid
  grouped = let
    step = acc: item:
      if item ? url
      then acc // {pending = acc.pending ++ [item];}
      else {
        groups =
          acc.groups
          ++ lib.optional (acc.pending != []) {
            isRoot = true;
            items = acc.pending;
          }
          ++ [
            {
              isRoot = false;
              item = item;
            }
          ];
        pending = [];
      };
    result =
      lib.foldl' step {
        groups = [];
        pending = [];
      }
      bookmarkList;
  in
    result.groups
    ++ lib.optional (result.pending != []) {
      isRoot = true;
      items = result.pending;
    };

  mkSection = group:
    if group.isRoot
    then ''
      <div class="folder-section">
        <div class="cards">
          ${lib.concatMapStrings mkCard group.items}
        </div>
      </div>
    ''
    else ''
      <div class="folder-section">
        <h2 class="folder-title">${group.item.name}</h2>
        <div class="cards">
          ${lib.concatMapStrings mkCard group.item.bookmarks}
        </div>
      </div>
    '';

  publicBookmarks =
    pkgs.writeText "qutebrowser-public-bookmarks"
    (lib.concatMapStrings (
        item:
          if item ? url
          then "${item.url} ${item.name}\n"
          else lib.concatMapStrings (b: "${b.url} ${item.name}/${b.name}\n") item.bookmarks
      )
      bookmarkList);

  privateBookmarksPath = config.qutebrowser.privateBookmarksPath;
in {
  options.qutebrowser.privateBookmarksPath = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "Path to a file containing extra (private) bookmarks to append.";
  };

  config = {
    # Fully static HTML — order is preserved, no dependency on qutebrowser's Jinja rendering
    xdg.dataFile."qutebrowser/bookmarks.html".text = ''
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Bookmarks</title>
        <style>
          *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

          body {
            background-color: #${c.base00};
            color: #${c.base05};
            font-family: 'Source Sans Pro', sans-serif;
            font-size: 14px;
            min-height: 100vh;
            padding: 2.5rem 2rem;
          }

          .header {
            max-width: 1100px;
            margin: 0 auto 2rem;
            display: flex;
            align-items: center;
            gap: 1.5rem;
          }

          .page-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #${c.base0D};
            letter-spacing: -0.01em;
            flex-shrink: 0;
          }

          .search-bar {
            flex: 1;
            background-color: #${c.base01};
            border: 1px solid #${c.base02};
            border-radius: 8px;
            color: #${c.base05};
            font-family: 'Source Sans Pro', sans-serif;
            font-size: 0.9rem;
            padding: 0.5rem 0.9rem;
            outline: none;
            transition: border-color 0.15s ease;
          }

          .search-bar::placeholder { color: #${c.base03}; }
          .search-bar:focus { border-color: #${c.base0D}; }

          .bookmarks-container {
            max-width: 1100px;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            gap: 1.75rem;
          }

          .folder-title {
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            color: #${c.base03};
            margin-bottom: 0.6rem;
            padding-left: 0.2rem;
          }

          .cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 0.4rem;
          }

          .card {
            display: flex;
            align-items: center;
            gap: 0.7rem;
            padding: 0.6rem 0.8rem;
            background-color: #${c.base01};
            border: 1px solid #${c.base02};
            border-radius: 10px;
            text-decoration: none;
            transition: background-color 0.12s ease, border-color 0.12s ease;
            overflow: hidden;
          }

          .card:hover {
            background-color: #${c.base02};
            border-color: #${c.base03};
          }

          .favicon-wrapper { position: relative; width: 18px; height: 18px; flex-shrink: 0; }

          .favicon-fallback {
            position: absolute;
            inset: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #${c.base02};
            border-radius: 4px;
            color: #${c.base04};
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            user-select: none;
          }

          .card-info {
            display: flex;
            flex-direction: column;
            gap: 0.05rem;
            overflow: hidden;
            flex: 1;
          }

          .card-name {
            color: #${c.base05};
            font-size: 0.86rem;
            font-weight: 500;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            transition: color 0.12s ease;
          }

          .card:hover .card-name { color: #${c.base0A}; }

          .card-url {
            color: #${c.base03};
            font-family: 'Maple Mono NF', monospace;
            font-size: 0.7rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
          }

          .no-results {
            color: #${c.base03};
            font-size: 0.9rem;
            padding: 0.5rem 0.2rem;
            display: none;
          }
        </style>
      </head>
      <body>
        <div class="header">
          <h1 class="page-title">Bookmarks</h1>
          <input id="search" class="search-bar" type="text" placeholder="Search…" autocomplete="off" spellcheck="false">
        </div>
        <div class="bookmarks-container">
          <p id="no-results" class="no-results">No results</p>
          ${lib.concatMapStrings mkSection grouped}
        </div>
        <script>
          window.addEventListener('DOMContentLoaded', function () {
            const input = document.getElementById('search');
            const noResults = document.getElementById('no-results');

            input.focus();

            input.addEventListener('input', function () {
              const query = this.value.toLowerCase().trim();
              let anyVisible = false;

              document.querySelectorAll('.folder-section').forEach(function (section) {
                let sectionVisible = false;
                section.querySelectorAll('.card').forEach(function (card) {
                  const name = card.querySelector('.card-name').textContent.toLowerCase();
                  const url = card.querySelector('.card-url').textContent.toLowerCase();
                  const match = !query || name.includes(query) || url.includes(query);
                  card.style.display = match ? ''' : 'none';
                  if (match) { sectionVisible = true; anyVisible = true; }
                });
                section.style.display = sectionVisible ? ''' : 'none';
              });

              noResults.style.display = anyVisible || !query ? 'none' : 'block';
            });

            input.addEventListener('keydown', function (e) {
              if (e.key === 'Enter') {
                const first = document.querySelector('.card:not([style*="none"])');
                if (first) {
                  location.href = first.href;
                } else {
                  const q = encodeURIComponent(this.value.trim());
                  if (q) location.href = 'https://www.startpage.com/sp/search?q=' + q;
                }
              }
              if (e.key === 'Escape') {
                this.value = ''';
                this.dispatchEvent(new Event('input'));
              }
            });
          });
        </script>
      </body>
      </html>
    '';

    home.activation.qutebrowserBookmarks = lib.hm.dag.entryAfter ["setupSecrets" "writeBoundary"] ''
      mkdir -p ${config.home.homeDirectory}/.config/qutebrowser/bookmarks
      cat ${publicBookmarks} ${lib.optionalString (privateBookmarksPath != null) ''"${privateBookmarksPath}"''} \
        > ${config.home.homeDirectory}/.config/qutebrowser/bookmarks/urls
    '';
  };
}
