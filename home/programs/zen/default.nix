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
        pins = import ./pins.nix;
        spaces = import ./spaces.nix;
        keyboardShortcuts = [
          # Remaps
          {
            id = "focusURLBar";
            key = " ";
            modifiers.control = true;
          }
          {
            id = "key_newNavigator";
            key = "n";
            modifiers.accel = true;
          }
          {
            id = "viewBookmarksToolbarKb";
            key = "s";
            modifiers.accel = true;
          }
          {
            id = "key_findAgain";
            disabled = true;
          }
          {
            id = "key_findPrevious";
            disabled = true;
          }
          {
            id = "key_privatebrowsing";
            key = "n";
            modifiers = {
              accel = true;
              shift = true;
            };
          }
          {
            id = "key_gotoHistory";
            key = "h";
            modifiers = {
              accel = true;
              shift = true;
            };
          }
          {
            id = "goBackKb";
            key = "h";
            modifiers.accel = true;
          }
          {
            id = "goForwardKb";
            key = "l";
            modifiers.accel = true;
          }

          # Disabled shortcuts
          {
            id = "printKb";
            disabled = true;
          }
          {
            id = "zen-close-all-unpinned-tabs";
            disabled = true;
          }
          {
            id = "zen-new-empty-split-view";
            disabled = true;
          }
          {
            id = "zen-split-view-unsplit";
            disabled = true;
          }
          {
            id = "zen-split-view-horizontal";
            disabled = true;
          }
          {
            id = "zen-split-view-vertical";
            disabled = true;
          }
          {
            id = "zen-split-view-grid";
            disabled = true;
          }
          {
            id = "zen-glance-expand";
            disabled = true;
          }
          {
            id = "zen-toggle-pin-tab";
            disabled = true;
          }
          {
            id = "zen-toggle-sidebar";
            disabled = true;
          }
          {
            id = "zen-new-unsynced-window";
            disabled = true;
          }
          {
            id = "key_closeWindow";
            disabled = true;
          }
          {
            id = "key_quitApplication";
            disabled = true;
          }
          {
            id = "key_search";
            disabled = true;
          }
          {
            id = "key_search2";
            disabled = true;
          }
          {
            id = "focusURLBar2";
            disabled = true;
          }
          {
            id = "key_savePage";
            disabled = true;
          }
          {
            id = "key_togglePictureInPicture";
            disabled = true;
          }
          {
            id = "showAllHistoryKb";
            disabled = true;
          }
          {
            id = "addBookmarkAsKb";
            disabled = true;
          }
          {
            id = "manBookmarkKb";
            disabled = true;
          }
          {
            id = "viewBookmarksSidebarKb";
            disabled = true;
          }
          {
            id = "key_toggleMute";
            disabled = true;
          }
          {
            id = "key_switchTextDirection";
            disabled = true;
          }
          {
            id = "key_screenshot";
            disabled = true;
          }
          {
            id = "key_viewInfo";
            disabled = true;
          }
          {
            id = "key_toggleToolbox";
            disabled = true;
          }
          {
            id = "key_browserToolbox";
            disabled = true;
          }
          {
            id = "key_browserConsole";
            disabled = true;
          }
          {
            id = "key_responsiveDesignMode";
            disabled = true;
          }
          {
            id = "key_inspector";
            disabled = true;
          }
          {
            id = "key_webconsole";
            disabled = true;
          }
          {
            id = "key_jsdebugger";
            disabled = true;
          }
          {
            id = "key_netmonitor";
            disabled = true;
          }
          {
            id = "key_styleeditor";
            disabled = true;
          }
          {
            id = "key_performance";
            disabled = true;
          }
          {
            id = "key_storage";
            disabled = true;
          }
          {
            id = "key_dom";
            disabled = true;
          }
          {
            id = "key_accessibility";
            disabled = true;
          }
          {
            id = "key_openDownloads";
            disabled = true;
          }
          {
            id = "key_openAddons";
            disabled = true;
          }
          {
            id = "key_reload";
            disabled = true;
          }
          {
            id = "key_reload2";
            disabled = true;
          }
          {
            id = "key_reload_skip_cache";
            disabled = true;
          }
          {
            id = "key_reload_skip_cache2";
            disabled = true;
          }
          {
            id = "key_enterFullScreen";
            disabled = true;
          }
          {
            id = "key_exitFullScreen";
            disabled = true;
          }
          {
            id = "key_aboutProcesses";
            disabled = true;
          }
          {
            id = "viewGenaiChatSidebarKb";
            disabled = true;
          }
          {
            id = "toggleSidebarKb";
            disabled = true;
          }
          {
            id = "key_showAllTabs";
            disabled = true;
          }
          {
            id = "key_sanitize";
            disabled = true;
          }
          {
            id = "key_wrCaptureCmd";
            disabled = true;
          }
          {
            id = "key_wrToggleCaptureSequenceCmd";
            disabled = true;
          }
          {
            id = "goHome";
            disabled = true;
          }
          {
            id = "goBackKb2";
            disabled = true;
          }
          {
            id = "goForwardKb2";
            disabled = true;
          }
        ];
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
