{pkgs, ...}: {
  xdg.dataFile = {
    # Startpage: hide sponsored results (custom script, no upstream)
    "qutebrowser/greasemonkey/startpage-no-ads.user.js".text = ''
      // ==UserScript==
      // @name        Startpage - Hide Ads
      // @match       https://www.startpage.com/*
      // @run-at      document-start
      // ==/UserScript==

      new MutationObserver(function(mutations) {
        mutations.forEach((mutation) => {
          if (mutation.type === 'childList') {
            mutation.addedNodes.forEach((node) => {
              if (node.nodeType === 1 && node.nodeName === 'DIV' && node.id === 'gcsa-top') {
                node.remove();
                this.disconnect();
              }
            });
          }
        });
      }).observe(document, { childList: true, subtree: true });
    '';

    # Return YouTube Dislike: restore dislike counts on YouTube
    "qutebrowser/greasemonkey/return-youtube-dislike.user.js".source = pkgs.fetchurl {
      url = "https://update.greasyfork.org/scripts/436115/Return%20YouTube%20Dislike.user.js";
      hash = "sha256-P7dK3v1WbSQaJUo73iHrezkXE+6BOdIuDk/D6GJwwbM=";
    };

    # SponsorBlock Lite: auto-skip sponsors on YouTube
    "qutebrowser/greasemonkey/sponsorblock-lite.user.js".source = pkgs.fetchurl {
      url = "https://update.greasyfork.org/scripts/560869/SponsorBlock%20Lite.user.js";
      hash = "sha256-8DTIRMn+cy/gZeeHa6xJDomQ5QN3lnaK0DG5ZcS5d00=";
    };

    # Don't Track Me Google: remove Google tracking redirects
    "qutebrowser/greasemonkey/dont-track-me-google.user.js".source = pkgs.fetchurl {
      url = "https://update.greasyfork.org/scripts/428243/Don%27t%20track%20me%20Google.user.js";
      hash = "sha256-yEjBZprSjHyDRpd+TJ1vUsSYHrwLspQOztpKunBLPig=";
    };

    # I don't care about cookies: auto-dismiss cookie banners
    "qutebrowser/greasemonkey/i-dont-care-about-cookies.user.js".source = pkgs.fetchurl {
      url = "https://update.greasyfork.org/scripts/522645/I%20don%27t%20care%20about%20cookies.user.js";
      hash = "sha256-Ij7HyBfWemAO0EAGKYxWPPv7OX5twNtGKKPGhOAxM9w=";
    };

    # TrackingTokenStripper: remove tracking params from URLs (utm_*, fbclid, etc.)
    "qutebrowser/greasemonkey/tracking-token-stripper.user.js".source = pkgs.fetchurl {
      url = "https://github.com/doggy8088/TrackingTokenStripper/raw/refs/heads/master/TrackingTokenStripper.user.js";
      hash = "sha256-EX8xN2Vd8SE/RvMcF/YSGN4Epa5cm355IeD9agTP2h4=";
    };

    # Bypass Paywalls Clean: bypass news site paywalls (Le Monde, NY Times, etc.)
    "qutebrowser/greasemonkey/bypass-paywalls-clean.user.js".source = pkgs.fetchurl {
      url = "https://gitflic.ru/project/magnolia1234/bypass-paywalls-clean-filters/blob/raw?file=userscript/bpc.en.user.js";
      hash = "sha256-dUgwBkJi5Jrtpw5HJydRjY9xBpZXyD0ZtA/+hDzF97s=";
    };

    # Anti-Adblock Fuckoff: remove anti-adblock modals and restore scroll
    "qutebrowser/greasemonkey/anti-adblock-fuckoff.user.js".source = pkgs.fetchurl {
      url = "https://update.greasyfork.org/scripts/397070/Anti-AdBlocker%20Fuckoff.user.js";
      hash = "sha256-vFeWxqMg0gPHP7mGNZO9e9Me/2Z81biR5JEXC/Ct4fA=";
    };
  };
}
