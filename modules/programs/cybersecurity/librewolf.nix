# LibreWolf dedicated to security testing: "sec" profile, no history,
# pre-installed extensions.
{config, ...}: let
  inherit (config) theme;
  c = theme.withHashtag;
in {
  flake.modules.nixos.cybersecurity = {
    hjem.extraModules = [
      ({
        config,
        lib,
        pkgs,
        ...
      }: let
        home = config.directory;
        certDir = "${home}/Cyber/certs";
        addons = pkgs.nur.repos.rycee.firefox-addons;

        js-recon-buddy = addons.buildFirefoxXpiAddon {
          pname = "js-recon-buddy";
          version = "1.20.2";
          addonId = "@jsrecon-buddy";
          url = "https://addons.mozilla.org/firefox/downloads/file/4670972/js_recon_buddy-1.20.2.xpi";
          sha256 = "e61b2c5940ca63b99bde206b8801f13a868008ecf433a329814e1eeb5903e935";
          meta.platforms = pkgs.lib.platforms.all;
        };

        extensions = [
          addons.foxyproxy-standard
          addons.wappalyzer
          addons.multi-account-containers
          js-recon-buddy
        ];

        # Stored in browser-extension-data/<id>/storage.js
        extensionSettings = {
          "wappalyzer@crunchlabz.com" = {
            version = lib.getVersion addons.wappalyzer;
            termsAccepted = true;
            tracking = false;
            upgradeMessage = false;
          };

          "foxyproxy@eric.h.jung" = {
            mode = "127.0.0.1:8080";
            passthrough = "";
            data = [
              {
                active = true;
                title = "spilltea";
                type = "http";
                hostname = "127.0.0.1";
                port = "8080";
                color = "#ff7f50";
                proxyDNS = true;
                include = [];
                exclude = [];
                tabProxy = [];
              }
            ];
          };
        };

        policies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DontCheckDefaultBrowser = true;
          OverrideFirstRunPage = "";
          OverridePostUpdatePage = "";
          PasswordManagerEnabled = false;
          OfferToSaveLogins = false;
          DisableFormHistory = true;
          Certificates.Install = [
            "${certDir}/burp.der"
            "${certDir}/caido.crt"
            "${home}/.local/share/spilltea/mitmproxy-ca-cert.pem"
          ];
          # FoxyProxy needs private window access to drive proxy.settings
          ExtensionSettings."foxyproxy@eric.h.jung".private_browsing = true;
          SanitizeOnShutdown = {
            Cache = true;
            Cookies = true;
            History = true;
            FormData = true;
            Sessions = true;
            SiteSettings = true;
            Locked = true;
          };
        };

        fontSize = builtins.floor (theme.fonts.sizes.applications * 4.0 / 3.0 + 0.5); # pt -> px

        settings = {
          # Enable extensions installed by Nix without asking
          "extensions.autoDisableScopes" = 0;
          # Read extension settings from browser-extension-data
          "extensions.webextensions.ExtensionStorageIDB.enabled" = false;

          # No fingerprinting resistance (real UA, timezone, no letterboxing)
          "privacy.resistFingerprinting" = false;
          "privacy.resistFingerprinting.letterboxing" = false;
          "privacy.fingerprintingProtection" = false;

          # No automatic http -> https upgrade
          "dom.security.https_only_mode" = false;
          "dom.security.https_only_mode_pbm" = false;
          "dom.security.https_first" = false;
          "dom.security.https_first_pbm" = false;
          "dom.security.https_first_schemeless" = false;

          # Behave like a regular browser
          "browser.contentblocking.category" = "standard"; # LibreWolf: strict
          "network.http.referer.XOriginTrimmingPolicy" = 0; # LibreWolf: 2
          "privacy.globalprivacycontrol.enabled" = false; # no Sec-GPC header

          # Allow the proxy CA on pinned domains
          "security.cert_pinning.enforcement_level" = 1;

          # Always show the full URL
          "browser.urlbar.trimURLs" = false;

          # No history
          "places.history.enabled" = false;
          "browser.formfill.enable" = false;
          "signon.rememberSignons" = false;
          "browser.sessionstore.resume_from_crash" = false;

          # Less background noise in the proxy
          "network.captive-portal-service.enabled" = false;
          "network.connectivity-service.enabled" = false;
          "network.prefetch-next" = false;
          "network.dns.disablePrefetch" = true;
          "network.http.speculative-parallel-limit" = 0;
          "browser.urlbar.speculativeConnect.enabled" = false;
          "browser.places.speculativeConnect.enabled" = false;
          "dom.push.enabled" = false;

          # Let the proxy intercept localhost / 127.0.0.1
          "network.proxy.allow_hijacking_localhost" = true;

          # Theme
          "font.name.monospace.x-western" = theme.fonts.monospace;
          "font.name.sans-serif.x-western" = theme.fonts.sansSerif;
          "font.name.serif.x-western" = theme.fonts.serif;
          "font.size.monospace.x-western" = fontSize;
          "font.size.variable.x-western" = fontSize;
          "reader.color_scheme" = "custom";
          "reader.custom_colors.background" = c.base00;
          "reader.custom_colors.foreground" = c.base05;
          "reader.custom_colors.selection-highlight" = c.base04;
          "reader.custom_colors.unvisited-links" = c.base0D;
          "reader.custom_colors.visited-links" = c.base0E;
        };

        profileDir = ".librewolf/sec";
      in {
        packages = [
          (pkgs.librewolf.override (old: {
            extraPolicies = (old.extraPolicies or {}) // policies;
          }))
        ];

        files =
          {
            ".librewolf/profiles.ini".text = lib.generators.toINI {} {
              General = {
                StartWithLastProfile = 1;
                Version = 2;
              };
              Profile0 = {
                Name = "sec";
                Path = "sec";
                IsRelative = 1;
                Default = 1;
              };
            };

            "${profileDir}/user.js".text = lib.concatLines (
              lib.mapAttrsToList (k: v: "user_pref(${builtins.toJSON k}, ${builtins.toJSON v});") settings
            );
          }
          // lib.listToAttrs (map (ext: {
              name = "${profileDir}/extensions/${ext.addonId}.xpi";
              value.source = "${ext}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${ext.addonId}.xpi";
            })
            extensions)
          // lib.mapAttrs' (id: s: {
            name = "${profileDir}/browser-extension-data/${id}/storage.js";
            value.text = builtins.toJSON s;
          })
          extensionSettings;
      })
    ];
  };
}
