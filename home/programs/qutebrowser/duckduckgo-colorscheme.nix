{ config, ... }:
let
  accent = config.lib.stylix.colors.base0D;
  background = config.lib.stylix.colors.base00;
  foreground = config.lib.stylix.colors.base05;
  background-alt = config.lib.stylix.colors.base01;
  foreground-alt = config.lib.stylix.colors.base06;
in {
  home.file.".duckduckgo-colorscheme.js".text =
    # js
    ''
      // Go to DuckDuckGo settings page, open the console, paste the code and hit enter.
      // based on https://ddg.codingcodax.dev/
      // Cookies string for your theme
      const cookie = '7=${background}; j=${background}; 9=${foreground}; aa=${foreground-alt}; 8=${foreground}; x=${accent}; 21=${background-alt};';

      // Converts cookie string into formatted JSON
      const cookieToJSON = (cookieRaw) => {
        const cookieJson = {};
        const items = cookieRaw.split(/[ ,]+/);

        items.forEach((item) => {
          const parts = item.split('=');
          cookieJson[parts[0]] = parts[1];
        });

        return cookieJson;
      };

      // Iterates over JSON, and adds to browser cookie store
      const setCookies = (cookieJson) => {
        Object.keys(cookieJson).forEach((key) => {
          document.cookie = `''${key}=''${cookieJson [ key ]}`;
        });
      };

      // Call set cookies, passing in formated cookie data
      setCookies(cookieToJSON(cookie));

      // All done, reload page for changes to take effect :)
      location.reload();
    '';
}
