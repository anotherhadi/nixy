{
  config,
  lib,
  pkgs,
  ...
}: {
  xdg.dataFile."qutebrowser/greasemonkey/startpage-no-ads.user.js".text = ''
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

  home.activation.downloadUserscripts = lib.hm.dag.entryAfter ["writeBoundary"] ''
    scripts_dir="${config.home.homeDirectory}/.local/share/qutebrowser/greasemonkey"
    $DRY_RUN_CMD mkdir -p "$scripts_dir"

    download() {
      local name="$1" url="$2"
      if [[ ! -f "$scripts_dir/$name" ]]; then
        $DRY_RUN_CMD ${pkgs.curl}/bin/curl -sSL -o "$scripts_dir/$name" "$url" || true
      fi
    }

    download "return-youtube-dislike.user.js"    "https://update.greasyfork.org/scripts/436115/Return%20YouTube%20Dislike.user.js"
    download "sponsorblock-lite.user.js"         "https://update.greasyfork.org/scripts/560869/SponsorBlock%20Lite.user.js"
    download "dont-track-me-google.user.js"      "https://update.greasyfork.org/scripts/428243/Don%27t%20track%20me%20Google.user.js"
    download "i-dont-care-about-cookies.user.js" "https://update.greasyfork.org/scripts/522645/I%20don%27t%20care%20about%20cookies.user.js"
    download "tracking-token-stripper.user.js"   "https://github.com/doggy8088/TrackingTokenStripper/raw/refs/heads/master/TrackingTokenStripper.user.js"
    download "bypass-paywalls-clean.user.js"     "https://gitflic.ru/project/magnolia1234/bypass-paywalls-clean-filters/blob/raw?file=userscript/bpc.en.user.js"
    download "anti-adblock-fuckoff.user.js"      "https://update.greasyfork.org/scripts/397070/Anti-AdBlocker%20Fuckoff.user.js"
  '';
}
