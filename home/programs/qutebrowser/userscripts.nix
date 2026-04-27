{
  pkgs,
  inputs,
  ...
}: {
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

    "qutebrowser/greasemonkey/return-youtube-dislike.user.js".source = inputs.qs-return-youtube-dislike;
    "qutebrowser/greasemonkey/sponsorblock-lite.user.js".source = inputs.qs-sponsorblock-lite;
    "qutebrowser/greasemonkey/dont-track-me-google.user.js".source = inputs.qs-dont-track-me-google;
    "qutebrowser/greasemonkey/i-dont-care-about-cookies.user.js".source = inputs.qs-i-dont-care-about-cookies;
    "qutebrowser/greasemonkey/tracking-token-stripper.user.js".source = inputs.qs-tracking-token-stripper;
    "qutebrowser/greasemonkey/bypass-paywalls-clean.user.js".source = inputs.qs-bypass-paywalls-clean;
    "qutebrowser/greasemonkey/anti-adblock-fuckoff.user.js".source = inputs.qs-anti-adblock-fuckoff;
  };
}
