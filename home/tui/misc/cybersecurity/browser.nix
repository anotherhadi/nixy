# LibreWolf dedicated to security testing: "sec" profile, no history,
# pre-installed extensions.
{
  pkgs,
  config,
  ...
}: let
  certDir = "${config.home.homeDirectory}/Cyber/certs";
  addons = pkgs.nur.repos.rycee.firefox-addons;

  js-recon-buddy = addons.buildFirefoxXpiAddon {
    pname = "js-recon-buddy";
    version = "1.20.2";
    addonId = "@jsrecon-buddy";
    url = "https://addons.mozilla.org/firefox/downloads/file/4670972/js_recon_buddy-1.20.2.xpi";
    sha256 = "e61b2c5940ca63b99bde206b8801f13a868008ecf433a329814e1eeb5903e935";
    meta.platforms = pkgs.lib.platforms.all;
  };
in {
  stylix.targets.librewolf.profileNames = ["sec"];

  programs.librewolf = {
    enable = true;

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
        "${config.home.homeDirectory}/.local/share/spilltea/mitmproxy-ca-cert.pem"
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

    profiles.sec = {
      id = 0;
      isDefault = true;

      extensions = {
        force = true;
        packages = [
          addons.foxyproxy-standard
          addons.wappalyzer
          addons.multi-account-containers
          js-recon-buddy
        ];

        settings."wappalyzer@crunchlabz.com".settings = {
          version = pkgs.lib.getVersion addons.wappalyzer;
          termsAccepted = true;
          tracking = false;
          upgradeMessage = false;
        };

        settings."foxyproxy@eric.h.jung".settings = {
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

      settings = {
        # Enable extensions installed by Nix without asking
        "extensions.autoDisableScopes" = 0;

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
      };
    };
  };
}
