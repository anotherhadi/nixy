{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-esr;

    profiles = {
      default = {
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          vimium
          sponsorblock
          youtube-recommended-videos
          scroll_anywhere
          newtab-adapter
          plasma-integration
        ];
      };

      settings = {

        webgl.disabled = true;
        "layers.acceleration.force-enabled" = true;
        toolkit.legacyUserProfileCustomizations.stylesheets = true;

        # ----------------------------------------------
        # Browser
        # ----------------------------------------------

        browser.aboutConfig.showWarning = false;

        browser.uidensity = 1;
        compactmode.show = true;
        tabs.warnOnClose = false;

        aboutwelcome.enabled = false;
        bookmarks.restore_default_bookmarks = false;
        contentblocking.category = "standard";
        ctrlTab.sortByRecentlyUsed = true;

        newtabpage = {
          enabled = false;

          activity-stream = {
            showSearch = false;
            newtabpage.activity-stream.showSponsored = false;
            newtabpage.activity-stream.showSponsoredTopSites = false;
            newtabpage.activity-stream.showWeather = false;
            newtabpage.activity-stream.system.showSponsored = false;
          };
        };

        # ----------------------------------------------
        # Sensors
        # ----------------------------------------------

        device.sensors.enabled = false;
        device.sensors.motion.enabled = false;
        extensions.pocket.enabled = false;

        geo.enabled = false;

        # ----------------------------------------------
        # Network
        # ----------------------------------------------

        network.trr.custom_uri = "https://dns.quad9.net/dns-query";
        network.trr.uri = "https://dns.quad9.net/dns-query";

        # ----------------------------------------------
        # Privacy
        # ----------------------------------------------

        privacy = {
          bounceTrackingProtection.hasMigratedUserActivationData = true;
          donottrackheader.enabled = true;
          fingerprintingProtection = true;
          globalprivacycontrol.enabled = true;
          globalprivacycontrol.was_ever_enabled = true;
          resistFingerprinting = true;
        };

        # ----------------------------------------------
        # Services
        # ----------------------------------------------

        services.sync.engine.addons = false;
        services.sync.nextSync = 0;

        signon.firefoxRelay.feature = "disabled";
        signon.generation.enabled = "false";
      };

      userChrome = ''
          /* Base color for the theme, dependent on whether it's a light theme or not */
          @media (prefers-color-scheme: dark) {
            :root {
              --accent-color: #11111b;
            }
          }

          @media (prefers-color-scheme: light) {
            :root {
              --accent-color: #dce0e8;
            }
          }

          /*====== Aesthetics ======*/

          #navigator-toolbox {
            border-bottom: none !important;
          }

          #titlebar {
            background: var(--accent-color) !important;
          }

          /* Sets the toolbar color */
          toolbar#nav-bar {
            background: var(--accent-color) !important;
            box-shadow: none !important;
          }

          /* Sets the URL bar color */
          #urlbar {
            background: var(--accent-color) !important;
          }

          #urlbar-background {
            background: var(--accent-color) !important;
            border: none !important;
          }

          #urlbar-input-container {
            border: none !important;
          }

          /*====== UI Settings ======*/

          :root {
            --navbarWidth: 500px;
            /* Set width of navbar */
          }

          /* If the window is wider than 1000px, use flex layout */
          @media (min-width: 1000px) {
            #navigator-toolbox {
              display: flex;
              flex-direction: row;
              flex-wrap: wrap;
            }

            /*  Url bar  */
            #nav-bar {
              order: 2;
              width: var(--navbarWidth);
            }

            /* Tab bar */
            #titlebar {
              order: 1;
              width: calc(100vw - var(--navbarWidth) - 1px);
            }

            /* Bookmarks bar */
            #PersonalToolbar {
              order: 3;
              width: 100%;
            }

            /* Fix urlbar sometimes being misaligned */
            :root[uidensity="compact"] #urlbar {
              --urlbar-toolbar-height: 39.60px !important;
            }

            :root[uidensity="touch"] #urlbar {
              --urlbar-toolbar-height: 49.00px !important;
            }
          }

          /*====== Simplifying interface ======*/

          /* Autohide back button when disabled */
          #back-button,
          #forward-button,
          /* Remove UI elements */
          #identity-box,
          /* Site information */
          #tracking-protection-icon-container,
          /* Shield icon */
          #page-action-buttons> :not(#urlbar-zoom-button, #star-button-box),
          /* All url bar icons except for zoom level and bookmarks */
          #urlbar-go-button,
          /* Search URL magnifying glass */
          #alltabs-button,
          /* Menu to display all tabs at the end of tabs bar */
          .titlebar-buttonbox-container

          /* Minimize, maximize, and close buttons */
            {
            display: none !important;
          }

          #nav-bar {
            box-shadow: none !important;
          }

          /* Remove "padding" left and right from tabs */
          .titlebar-spacer {
            display: none !important;
          }

          /* Fix URL bar overlapping elements */
          #urlbar-container {
            min-width: none !important;
          }

          /* Remove gap after pinned tabs */
          #tabbrowser-tabs[haspinnedtabs]:not([positionpinnedtabs])>#tabbrowser-arrowscrollbox>.tabbrowser-tab[first-visible-unpinned-tab] {
            margin-inline-start: 0 !important;
          }

          /* Hide the hamburger menu */
          #PanelUI-menu-button {
            padding: 0px !important;
          }

          #PanelUI-menu-button .toolbarbutton-icon {
            width: 0px !important;
          }

          #PanelUI-menu-button .toolbarbutton-badge-stack {
            padding: 0px !important;
        }'';
    };
  };
}
