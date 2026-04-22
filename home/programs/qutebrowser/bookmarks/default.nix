{
  config,
  lib,
  pkgs,
  ...
}: let
  bookmarkList =
    (import ./general.nix)
    ++ (import ./tools.nix)
    ++ (import ./social.nix)
    ++ (import ./infosec.nix)
    ++ (import ./other.nix)
    ++ (import ./jack.nix);

  c = config.lib.stylix.colors;

  stripProtocol = url:
    lib.removePrefix "https://" (lib.removePrefix "http://" url);

  stripDomain = url:
    builtins.head (
      lib.splitString "/" (stripProtocol url)
    );

  mkCard = item: let
    domain = stripDomain item.url;
    initial = builtins.substring 0 1 item.name;
  in ''
    <a href="${item.url}" class="card">
      <div class="favicon-wrapper">
        <img class="favicon" src="https://icons.duckduckgo.com/ip3/${domain}.ico" alt="" aria-hidden="true" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
        <span class="favicon-fallback" style="display:none">${initial}</span>
      </div>
      <div class="card-info">
        <span class="card-name">${item.name}</span>
        <span class="card-url">${stripProtocol item.url}</span>
      </div>
    </a>'';

  # Render a list of items (cards and/or sub-folders) inside a folder
  mkFolderContent = items: let
    step = acc: item:
      if item ? url
      then acc // {pending = acc.pending ++ [item];}
      else {
        chunks =
          acc.chunks
          ++ lib.optional (acc.pending != []) {
            isCards = true;
            items = acc.pending;
          }
          ++ [
            {
              isCards = false;
              folder = item;
            }
          ];
        pending = [];
      };
    result =
      lib.foldl' step {
        chunks = [];
        pending = [];
      }
      items;
    chunks =
      result.chunks
      ++ lib.optional (result.pending != []) {
        isCards = true;
        items = result.pending;
      };
  in
    lib.concatMapStrings (chunk:
      if chunk.isCards
      then ''
        <div class="cards">
          ${lib.concatMapStrings mkCard chunk.items}
        </div>''
      else mkFolder chunk.folder)
    chunks;

  mkFolder = folder: let
    iconHtml =
      if folder ? icon
      then ''<span class="material-symbols-outlined folder-icon" aria-hidden="true">${folder.icon}</span>''
      else "";
  in ''
    <details class="folder-section" open>
      <summary class="folder-title">
        ${iconHtml}<span class="folder-name">${folder.name}</span>
        <svg class="chevron" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="6 9 12 15 18 9"/></svg>
      </summary>
      <div class="folder-content">
        ${mkFolderContent folder.bookmarks}
      </div>
    </details>'';

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
              inherit item;
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
      <div class="root-section">
        <div class="cards">
          ${lib.concatMapStrings mkCard group.items}
        </div>
      </div>''
    else mkFolder group.item;

  # Recursively collect all leaf bookmarks with their full folder path
  collectBookmarks = prefix: items:
    lib.concatMapStrings (
      item:
        if item ? url
        then "${item.url} ${prefix}${item.name}\n"
        else collectBookmarks "${prefix}${item.name}/" item.bookmarks
    )
    items;

  publicBookmarks =
    pkgs.writeText "qutebrowser-public-bookmarks"
    (collectBookmarks "" bookmarkList);

  inherit (config.qutebrowser) privateBookmarksPath;
in {
  options.qutebrowser.privateBookmarksPath = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "Path to a file containing extra (private) bookmarks to append.";
  };

  config = {
    xdg.dataFile."qutebrowser/bookmarks.html".text = ''
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Bookmarks</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,300,0,0">
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

          .collapse-btn {
            flex-shrink: 0;
            background: none;
            border: 1px solid #${c.base02};
            border-radius: 8px;
            color: #${c.base03};
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0.47rem;
            transition: color 0.15s ease, border-color 0.15s ease;
          }

          .collapse-btn:hover {
            color: #${c.base0D};
            border-color: #${c.base0D};
          }

          .collapse-btn svg {
            width: 16px;
            height: 16px;
          }

          .bookmarks-container {
            max-width: 1100px;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
          }

          .root-section {
            margin-bottom: 1rem;
          }

          details.folder-section {
            border-radius: 8px;
          }

          details.folder-section > summary {
            list-style: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.45rem 0.5rem;
            border-radius: 8px;
            user-select: none;
            transition: background-color 0.12s ease;
          }

          details.folder-section > summary::-webkit-details-marker { display: none; }

          details.folder-section > summary:hover {
            background-color: #${c.base01};
            color: #${c.base0D};
          }

          details.folder-section > summary:hover .folder-name {
            color: #${c.base0D};
          }

          details.folder-section > summary:hover .folder-icon {
            color: #${c.base0D};
          }

          .folder-icon {
            font-size: 14px;
            line-height: 1;
            flex-shrink: 0;
            color: #${c.base04};
            user-select: none;
          }

          .folder-name {
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            color: #${c.base03};
            flex: 1;
          }

          .chevron {
            width: 13px;
            height: 13px;
            color: #${c.base03};
            transition: transform 0.2s ease;
            flex-shrink: 0;
          }

          details[open] > summary > .chevron {
            transform: rotate(180deg);
          }

          .folder-content {
            padding: 0.4rem 0 0.5rem 0;
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
          }

          /* Nested folder indent */
          .folder-content > details.folder-section > summary {
            padding-left: 1.2rem;
          }

          .folder-content > details.folder-section > .folder-content {
            padding-left: 1rem;
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
            border-color: #${c.base0D};
          }

          .favicon-wrapper { position: relative; width: 18px; height: 18px; flex-shrink: 0; }

          .favicon {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            object-fit: contain;
            border-radius: 3px;
          }

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

          .card:hover .card-name { color: #${c.base0D}; }

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
          <button id="collapse-btn" class="collapse-btn" title="Collapse all folders" aria-label="Collapse all folders">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <polyline points="4 14 10 14 10 20"/><polyline points="20 10 14 10 14 4"/><line x1="10" y1="14" x2="3" y2="21"/><line x1="21" y1="3" x2="14" y2="10"/>
            </svg>
          </button>
        </div>
        <div class="bookmarks-container">
          <p id="no-results" class="no-results">No results</p>
          ${lib.concatMapStrings mkSection grouped}
        </div>
        <script>
          window.addEventListener('DOMContentLoaded', function () {
            const input = document.getElementById('search');
            const noResults = document.getElementById('no-results');
            const collapseBtn = document.getElementById('collapse-btn');

            input.focus();

            collapseBtn.addEventListener('click', function () {
              document.querySelectorAll('details.folder-section').forEach(function (d) {
                d.open = false;
              });
            });

            input.addEventListener('input', function () {
              const query = this.value.toLowerCase().trim();
              let anyVisible = false;

              if (query) {
                document.querySelectorAll('details.folder-section').forEach(function (d) {
                  d.open = true;
                });
              }

              document.querySelectorAll('.folder-section, .root-section').forEach(function (section) {
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
                const val = this.value.trim();
                const isUrl = /^https?:\/\//i.test(val) || /^[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})(\/.*)?$/.test(val);
                if (isUrl) {
                  location.href = /^https?:\/\//i.test(val) ? val : 'https://' + val;
                } else {
                  const first = document.querySelector('.card:not([style*="none"])');
                  if (first) {
                    location.href = first.href;
                  } else {
                    const q = encodeURIComponent(val);
                    if (q) location.href = 'https://www.startpage.com/sp/search?q=' + q;
                  }
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

    home.activation.qutebrowserBookmarks = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p ${config.home.homeDirectory}/.config/qutebrowser/bookmarks
      {
        cat ${publicBookmarks}
        ${lib.optionalString (privateBookmarksPath != null) ''
        if [ -f "${privateBookmarksPath}" ]; then
          cat "${privateBookmarksPath}"
        fi
      ''}
      } > ${config.home.homeDirectory}/.config/qutebrowser/bookmarks/urls
    '';
  };
}
