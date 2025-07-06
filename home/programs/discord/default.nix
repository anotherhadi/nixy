{ inputs, config, ... }:

let
  myColors = {
    base00 = "#${config.lib.stylix.colors.base00}";
    base01 = "#${config.lib.stylix.colors.base01}";
    base02 = "#${config.lib.stylix.colors.base02}";
    base03 = "#${config.lib.stylix.colors.base03}";
    base04 = "#${config.lib.stylix.colors.base04}";
    base05 = "#${config.lib.stylix.colors.base05}";
    base06 = "#${config.lib.stylix.colors.base06}";
    base07 = "#${config.lib.stylix.colors.base07}";
    base08 = "#${config.lib.stylix.colors.base08}";
    base09 = "#${config.lib.stylix.colors.base09}";
    base0A = "#${config.lib.stylix.colors.base0A}";
    base0B = "#${config.lib.stylix.colors.base0B}";
    base0C = "#${config.lib.stylix.colors.base0C}";
    base0D = "#${config.lib.stylix.colors.base0D}";
    base0E = "#${config.lib.stylix.colors.base0E}";
    base0F = "#${config.lib.stylix.colors.base0F}";
  };
in {
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.nixcord = {
    enable = true;
    quickCss = ''
      :root {
        --base00: ${myColors.base00};
        --base01: ${myColors.base01};
        --base02: ${myColors.base02};
        --base03: ${myColors.base03};
        --base04: ${myColors.base04};
        --base05: ${myColors.base05};
        --base06: ${myColors.base06};
        --base07: ${myColors.base07};
        --base08: ${myColors.base08};
        --base09: ${myColors.base09};
        --base0A: ${myColors.base0A};
        --base0B: ${myColors.base0B};
        --base0C: ${myColors.base0C};
        --base0D: ${myColors.base0D};
        --base0E: ${myColors.base0E};
        --base0F: ${myColors.base0F};

        --colors: on;

        --text-0: var(--base00);
        --text-1: var(--base07);
        --text-2: var(--base06);
        --text-3: var(--base05);
        --text-4: var(--base04);
        --text-5: var(--base03);

        --bg-1: var(--base02);
        --bg-2: var(--base01);
        --bg-3: var(--base00);
        --bg-4: var(--base01);

        --accent-1: var(--base0D);
        --accent-2: var(--base0D);
        --accent-3: var(--base0D);
        --accent-4: var(--base0D);
        --accent-5: var(--base0D);
        --accent-new: var(--base08);

        --border-thickness: 1px;
        --divider-thickness: 2px;

      }
    '';

    config = {
      useQuickCss = true;
      themeLinks = [
        "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/system24.theme.css"
      ];
      frameless = true;
      plugins = {
        biggerStreamPreview.enable    = true;
        callTimer.enable              = true;
        decor.enable                  = true;
        fixSpotifyEmbeds.enable       = true;
        friendsSince.enable           = true;
        gameActivityToggle.enable     = true;
        messageLogger.enable          = true;
        petpet.enable                 = true;
        reverseImageSearch.enable     = true;
        loadingQuotes = {
          enable                  = true;
          enablePluginPresetQuotes = false;
        };
      };
    };
  };
}
