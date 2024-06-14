{ config, ... }: {
  home.file.".duckduckgo-colorscheme.js".text = ''
    // Go to DuckDuckGo settings page, open the console, paste the code and hit enter.
    // based on https://ddg.codingcodax.dev/
    // Cookies string for your theme
    const cookie = '7=${config.var.theme.colors.bg}; j=${config.var.theme.colors.bg}; 9=${config.var.theme.colors.fg}; aa=${config.var.theme.colors.fgalt}; 8=${config.var.theme.colors.c7}; x=${config.var.theme.colors.accent}; 21=${config.var.theme.colors.bgalt};';

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
