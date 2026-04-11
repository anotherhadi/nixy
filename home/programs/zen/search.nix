{pkgs, ...}: {
  force = true;
  default = "Startpage";
  privateDefault = "Startpage";
  order = [
    "Startpage"
    "Gooogle"
    "Gooogle (Web)"
    "NixOS Packages"
    "NixOS Options"
    "NixOS Wiki"
    "Home Manager"
    "My NixOS"
    "Noogle"
    "ChatGPT"
    "Claude"
    "Gemini"
    "Yandex"
    "Google Maps"
  ];
  engines = let
    nix-icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    google-icon = "https://www.gstatic.com/images/branding/searchlogo/ico/favicon.ico";
  in {
    "Gooogle" = {
      urls = [
        {
          template = "https://www.google.com/search?num=50&q={searchTerms}";
        }
      ];
      icon = google-icon;
      definedAliases = ["@gs" "@google"];
    };
    "Gooogle (Web)" = {
      urls = [
        {
          template = "https://www.google.com/search?num=50&udm=14&q={searchTerms}";
        }
      ];
      icon = google-icon;
      definedAliases = ["@gw" "@googleweb"];
    };
    "Startpage" = {
      urls = [
        {
          template = "https://www.startpage.com/sp/search?query={searchTerms}";
        }
      ];
      icon = "https://www.startpage.com/sp/cdn/favicons/favicon-gradient.ico";
      definedAliases = ["@sp"];
      updateInterval = 24 * 60 * 60 * 1000;
    };
    "NixOS Packages" = {
      urls = [
        {
          template = "https://search.nixos.org/packages";
          params = [
            {
              name = "type";
              value = "packages";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = nix-icon;
      definedAliases = [
        "@np"
        "@nixpkgs"
      ];
    };
    "NixOS Options" = {
      urls = [
        {
          template = "https://search.nixos.org/options";
          params = [
            {
              name = "type";
              value = "packages";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = nix-icon;
      definedAliases = [
        "@no"
        "@nixopts"
      ];
    };
    "NixOS Wiki" = {
      urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
      icon = nix-icon;
      updateInterval = 24 * 60 * 60 * 1000; # every day
      definedAliases = ["@nw"];
    };
    "Home Manager" = {
      urls = [{template = "https://home-manager-options.extranix.com/?query={searchTerms}";}];
      icon = nix-icon;
      definedAliases = [
        "@hm"
        "@home"
        "'homeman"
      ];
    };
    "My NixOS" = {
      urls = [{template = "https://mynixos.com/search?q={searchTerms}";}];
      icon = nix-icon;
      definedAliases = [
        "@n"
        "@nx"
        "@mynixos"
      ];
    };
    "ChatGPT" = {
      urls = [
        {template = "https://chat.openai.com/?q={searchTerms}";}
      ];
      icon = "https://chatgpt.com/cdn/assets/favicon-eex17e9e.ico";
      definedAliases = ["@cg" "@chatgpt"];
    };
    "Claude" = {
      urls = [
        {template = "https://claude.ai/new?q={searchTerms}";}
      ];
      icon = "https://claude.ai/favicon.ico";
      definedAliases = ["@claude" "@cl"];
    };
    "Gemini" = {
      urls = [
        {template = "https://gemini.google.com/app?q={searchTerms}";}
      ];
      icon = "https://www.gstatic.com/lamda/images/gemini_favicon_f069958c85030456e93de685481c559f160ea06.svg";
      definedAliases = ["@gemini" "@gm"];
    };
    "Yandex" = {
      urls = [
        {template = "https://yandex.com/search/?text={searchTerms}";}
      ];
      icon = "https://yandex.com/favicon.ico";
      definedAliases = ["@yandex" "@ya"];
    };
    "Google Maps" = {
      urls = [
        {template = "https://www.google.com/maps/search/{searchTerms}";}
      ];
      icon = "https://www.google.com/images/branding/product/ico/maps15_bnuw3a_32dp.ico";
      definedAliases = ["@maps" "@gmaps"];
    };
    "bing".metaData.hidden = true;
    "ddg".metaData.hidden = true;
    "ebay".metaData.hidden = true;
    "google".metaData.hidden = true;
    "Perplexity".metaData.hidden = true;
  };
}
