{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.zen-browser.homeModules.beta];

  stylix.targets.zen-browser.profileNames = ["default"];

  home.sessionVariables = {
    MOZ_LEGACY_PROFILES = 1;
    DEFAULT_BROWSER = "zen-beta";
    BROWSER = "zen-beta";
  };

  programs.zen-browser = {
    enable = true;
    nativeMessagingHosts = [pkgs.firefoxpwa];
    policies = import ./policies.nix {inherit lib;};
    languagePacks = ["en-US" "fr"];
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        containersForce = true;
        pinsForce = true;
        spacesForce = true;

        settings = import ./settings.nix;
        bookmarks = import ./bookmarks.nix;
        search = import ./search.nix {inherit pkgs;};
        spaces = import ./spaces.nix;
        keyboardShortcuts = import ./keyboard-shortcuts.nix;

        extraConfig = ''
          // BETTERFOX
          // ${builtins.readFile "${inputs.betterfox}/user.js"} // The way we do it here, importing the others separately is better
          ${builtins.readFile "${inputs.betterfox}/Fastfox.js"}
          ${builtins.readFile "${inputs.betterfox}/Securefox.js"}
          ${builtins.readFile "${inputs.betterfox}/Peskyfox.js"}

          /****************************************************************************
           * START: MY OVERRIDES                                                      *
          ****************************************************************************/
          // Visit https://github.com/yokoffing/Betterfox/wiki/Common-Overrides
          // Visit https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening
          // Enter your personal overrides below this line:

          // Common Overrides
          user_pref("browser.contentblocking.features.strict", "tp,tpPrivate,cookieBehavior5,cookieBehaviorPBM5,cm,fp,stp,emailTP,emailTPPrivate,-lvl2,rp,rpTop,ocsp,qps,qpsPBM,fpp,fppPrivate,3pcd,btp"); // https://github.com/yokoffing/Betterfox/wiki/Common-Overrides#example
          user_pref("permissions.default.geo", 0); // https://github.com/yokoffing/Betterfox/wiki/Common-Overrides#location-requests
          user_pref("permissions.default.desktop-notification", 0); // https://github.com/yokoffing/Betterfox/wiki/Common-Overrides#site-notifications
          user_pref("browser.ml.linkPreview.enabled", true); // https://github.com/yokoffing/Betterfox/wiki/Common-Overrides#ai-features

          // Optional Hardening
          // Below 2 - https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening#firefox-sync--view
          user_pref("identity.fxaccounts.enabled", false); // PREF: disable Firefox Sync
          user_pref("browser.firefox-view.feature-tour", "{\"screen\":\"\",\"complete\":true}"); // PREF: disable the Firefox View tour from popping up
          // Below 3 - https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening#password-credit-card-and-address-management
          user_pref("signon.rememberSignons", false); // PREF: disable login manager
          user_pref("extensions.formautofill.addresses.enabled", false); // PREF: disable address and credit card manager
          user_pref("extensions.formautofill.creditCards.enabled", false); // PREF: disable address and credit card manager
          // TODO - Future? https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening#secure-dns
          // Below 3 - https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening#downloads
          user_pref("browser.download.useDownloadDir", true); // PREF: use default download directory
          user_pref("browser.download.always_ask_before_handling_new_types", false); // PREF: ask whether to open or save new file types
          user_pref("extensions.postDownloadThirdPartyPrompt", false); // PREF: display the installation prompt for all extensions
          // Below 1 - https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening#public-key-pinning
          user_pref("security.cert_pinning.enforcement_level", 2); // PREF: enforce certificate pinning, [ERROR] MOZILLA_PKIX_ERROR_KEY_PINNING_FAILURE, 1 = allow user MiTM (such as your antivirus) (default), 2 = strict

          /****************************************************************************
           * SECTION: SMOOTHFOX                                                       *
          ****************************************************************************/
          // Visit https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js
          // Enter your scrolling overrides below this line:
          // Section taken from https://github.com/yokoffing/Betterfox/blob/eee6e58b2b0ee10a59efb6586a5db07ae181d8c7/Smoothfox.js#L28
          // Advice at https://github.com/yokoffing/Betterfox/wiki/Common-Overrides#scrolling

          /****************************************************************************************
           * OPTION: INSTANT SCROLLING (SIMPLE ADJUSTMENT)                                       *
          ****************************************************************************************/
          // Recommended for 60hz+ displays
          user_pref("apz.overscroll.enabled", true); // DEFAULT NON-LINUX
          user_pref("general.smoothScroll", true); // DEFAULT
          user_pref("mousewheel.default.delta_multiplier_y", 275); // 250-400; adjust this number to your liking
          // Firefox Nightly only:
          // [1] https://bugzilla.mozilla.org/show_bug.cgi?id=1846935
          // user_pref("general.smoothScroll.msdPhysics.enabled", false); // [FF122+ Nightly]
        '';
      };
    };
  };
}
