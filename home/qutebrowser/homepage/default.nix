{ config, ... }:
let
  bookmarks = ''
    Bookmarks: [
      {text: "MyNixOs", url: "https://mynixos.com", icon: "󱄅"},
      {text: "Github", url: "https://github.com", icon: ""},
      {text: "Proton", url: "https://mail.proton.me/u/0/inbox", icon: ""},
      {text: "Cloudflare One", url: "https://one.dash.cloudflare.com/", icon: ""},
      {text: "Chat GPT", url: "https://chat.openai.com/", icon: "󰭹"},
      {text: "Nixvim", url: "https://nix-community.github.io/nixvim/", icon: ""},
      {text: "Hyprland Wiki", url: "https://wiki.hyprland.org/", icon: "󰖬"},
      {text: "Nerdfont", url: "https://www.nerdfonts.com/cheat-sheet", icon: ""},
      {text: "Youtube", url: "https://youtube.com", icon: "󰗃"},
    ],
    Home: [
      {text: "Casa", url: "http://192.168.2.16:8081/#/", icon: "󰋜"},
      {text: "Plex", url: "http://192.168.2.16:32400", icon: "󰚺"},
      {text: "Nextcloud", url: "http://192.168.2.16:10081", icon: ""},
    ],
    Work: [
      {text: "Outlook", url: "https://outlook.office.com/mail/", icon: "󰴢"},
      {text: "Office", url: "https://www.office.com/?auth=2", icon: "󰏆"},
      {text: "Teams", url: "https://teams.microsoft.com/_", icon: "󰊻"},
    ],
  '';
in {

  xdg.configFile."startpage/index.html".text = ''
    <!DOCTYPE html>
    <html lang="en">

    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Homepage</title>
      <style>
        h1,
        h2,
        h3,
        p {
          margin: 0;
          padding: 0;
        }

        .w-screen {
          width: 100vw;
        }

        .overflow-hidden {
          overflow: hidden;
        }

        .max-w-7xl {
          max-width: 80rem;
        }

        .mx-auto {
          margin-left: auto;
          margin-right: auto;
        }

        .justify-between {
          justify-content: space-between;
        }

        .items-center {
          align-items: center;
        }

        .py-12 {
          padding-top: 3rem;
          padding-bottom: 3rem;
        }

        .px-2 {
          padding-left: 0.5rem;
          padding-right: 0.5rem;
        }

        .text-5xl {
          font-size: 3rem;
          line-height: 1;
        }

        .font-bold {
          font-weight: 700;
        }

        .mb-4 {
          margin-bottom: 1rem;
        }

        .flex {
          display: flex;
        }

        .flex-wrap {
          flex-wrap: wrap;
        }

        .flex-col {
          flex-direction: column;
        }

        .flex-grow {
          flex-grow: 1;
        }

        .gap-5 {
          gap: 1.25rem;
        }

        .gap-05 {
          gap: 0.125rem;
        }

        .justify-start {
          justify-content: flex-start;
        }

        .items-start {
          align-items: flex-start;
        }

        .hover\:opacity-60:hover {
          opacity: 0.6;
        }

        .pb-10 {
          padding-bottom: 2.5rem;
        }

        .p-10 {
          padding: 2.5rem;
        }

        .text-xl {
          font-size: 1.25rem;
          line-height: 1.75rem;
        }

        .text-lg {
          font-size: 1.125rem;
          line-height: 1.75rem;
        }

        .text-sm {
          font-size: 0.875rem;
          line-height: 1.25rem;
        }

        .text-4xl {
          font-size: 2.25rem;
          line-height: 2.5rem;
        }

        .px-5 {
          padding-left: 1.25rem;
          padding-right: 1.25rem;
        }

        .py-2 {
          padding-top: 0.5rem;
          padding-bottom: 0.5rem;
        }

        a {
          text-decoration: none;
        }

        a, a:visited, a:hover, a:active {
          color: inherit;
        }
        </style>
    </head>

    <body class="w-screen" style="background-color: #${config.theme.colors.bg}; color: #${config.theme.colors.fg};">
      <div class="max-w-7xl mx-auto p-10">
        <div class="w-full flex justify-between" id="date-time">
          <p class="text-xl"></p>
          <p class="text-xl"></p>
        </div>
        <div class="w-full py-12 px-2" id="greeting">
          <h1 class="text-5xl font-bold mb-4" style="color: #${config.theme.colors.primary-bg};"></h1>
        </div>
        <div id="link-list" class="flex gap-5 flex-col justify-start items-start"></div>
      </div>
      <script defer>
        const linkLists = {
          ${bookmarks}
        };

        function getDomainFromUrl(url) {
          let domain = url.replace(/(^\w+:|^)\/\//, "");
          domain = domain.split('/')[0];
          return domain;
        }

        const linkListContainer = document.getElementById('link-list');

        for (const key in linkLists) {
          if (Object.hasOwnProperty.call(linkLists, key)) {
            const linkList = linkLists[key];
            const title = document.createElement('h2');
            title.textContent = key.charAt(0).toUpperCase() + key.slice(1);
            title.className = "text-3xl font-bold"
            linkListContainer.appendChild(title);

            const list = document.createElement('div');
            list.className = 'flex flex-wrap gap-5 justify-start';
            linkList.forEach(link => {
              const anchor = document.createElement('a');
              anchor.href = link.url;
              anchor.className = "px-5 py-2 hover:opacity-60 flex-grow"

              const div = document.createElement('div');
              div.className = 'flex flex-row gap-5 items-center';

              let icon = document.createElement('p');
              icon.textContent = link.icon || "";
              icon.className = "text-4xl";
              div.appendChild(icon);

              const divNameUrl = document.createElement('div');
              divNameUrl.className = 'flex flex-col gap-05';

              const name = document.createElement('p');
              name.textContent = link.text;
              name.className = 'text-lg font-medium';

              const url = document.createElement('p');
              url.textContent = link.url;
              url.className = 'text-sm';
              url.style = "color: #${config.theme.colors.alt-fg};"

              divNameUrl.appendChild(name);
              divNameUrl.appendChild(url);
              div.appendChild(divNameUrl);
              anchor.appendChild(div);
              list.appendChild(anchor);
            });

            linkListContainer.appendChild(list);
            const spacer = document.createElement('div');
            spacer.className = "pb-10"
            linkListContainer.appendChild(spacer);
          }
        }

        function updateDateTime() {
          const dateTimeContainer = document.getElementById('date-time');
          const currentDate = new Date();
          const dateOptions = {weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'};
          const timeOptions = {hour: '2-digit', minute: '2-digit'};
          const formattedDate = currentDate.toLocaleDateString('en-US', dateOptions);
          const formattedTime = currentDate.toLocaleTimeString('en-US', timeOptions);
          const dateParagraph = dateTimeContainer.querySelector('p:nth-child(1)');
          const timeParagraph = dateTimeContainer.querySelector('p:nth-child(2)');
          dateParagraph.textContent = formattedDate;
          timeParagraph.textContent = formattedTime;
        }

        updateDateTime();
        setInterval(updateDateTime, 60000);

        function updateGreeting() {
          const greetingContainer = document.getElementById('greeting');
          const currentDate = new Date();
          const currentHour = currentDate.getHours();
          let greetingText;

          if (currentHour < 2) {
            greetingText = "Good night! ";
          } else if (currentHour < 5) {
            greetingText = "Hello, night owl! 󰏒";
          } else if (currentHour < 12) {
            greetingText = "Good morning! ";
          } else if (currentHour < 17) {
            greetingText = "Good afternoon! ️";
          } else if (currentHour < 20) {
            greetingText = "Good evening! ";
          } else {
            greetingText = "Good night! ";
          }

          const greetingHeader = greetingContainer.querySelector('h1');
          greetingHeader.textContent = greetingText;
        }

        updateGreeting();
      </script>
    </body>

    </html>
  '';
}
