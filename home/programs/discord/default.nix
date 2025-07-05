# Discord is a popular chat application.
{ inputs, ... }: {
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.nixcord = {
    enable = true;
    config = { 
      themeLinks = ["https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/system24.theme.css"];
      frameless = true; 

      plugins = {
        biggerStreamPreview.enable = true;
        callTimer.enable = true;
        decor.enable = true;
        fixSpotifyEmbeds.enable = true;
        friendsSince.enable = true;
        gameActivityToggle.enable = true;
        messageLogger.enable = true;
        petpet.enable = true;
        reverseImageSearch.enable = true;

        loadingQuotes = {
          enable = true;
          enablePluginPresetQuotes = false;
        };
      };
    };
  };
}
