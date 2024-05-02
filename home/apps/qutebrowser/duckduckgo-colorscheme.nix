{ config, ... }: {

  xdg.configFile."duckduckgo-colorscheme.js".text = ''
    // Go to DuckDuckGo settings page, open the console, paste the code and hit enter.
    // based on https://ddg.codingcodax.dev/
    // Cookies string for your theme
    const cookie = '7=${config.theme.colors.bg}; j=${config.theme.colors.bg}; 9=${config.theme.colors.fg}; aa=${config.theme.colors.alt-fg}; 8=${config.theme.colors.color7}; x=${config.theme.colors.primary-bg}; 21=${config.theme.colors.alt-bg};';

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

    alert('The Nixy theme will be applied.');

    // Call set cookies, passing in formated cookie data
    setCookies(cookieToJSON(cookie));

    // All done, reload page for changes to take effect :)
    location.reload();
  '';
}
