let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in {
  # NO LONGER NEEDED WITH https://zen-browser.app/mods/e122b5d9-d385-4bf8-9971-e137809097d0/?page=3 YAY!
  "browser.newtabpage.activity-stream.feeds.system.topsites" = true;
  "browser.newtabpage.activity-stream.feeds.system.topstories" = true;

  "browser.aboutwelcome.enabled" = false;
  "browser.ctrlTab.sortByRecentlyUsed" = false;
  "browser.startup.page" = 1;
  "browser.startup.firstrunSkipsHomepage" = true;
  "browser.startup.homepage_override.mstone" = "ignore";
  "trailhead.firstrun.didSeeAboutWelcome" = true;

  # Do not tell what plugins we have enabled: https://mail.mozilla.org/pipermail/firefox-dev/2013-November/001186.html
  "plugins.enumerable_names" = "";
  "plugin.state.flash" = 0;
  "browser.search.update" = false;
  "extensions.getAddons.cache.enabled" = lock-false;
  "extensions.ui.sitepermission.hidden" = lock-true;
  "extensions.ui.locale.hidden" = lock-true;

  "layout.css.devPixelsPerPx" = -1;
  # "zen.theme.accent-color" = "#ffb787";
  "zen.theme.acrylic-elements" = false;
  "zen.theme.border-radius" = 8;
  "zen.theme.content-element-separation" = 0;
  "zen.theme.dark-mode-bias" = 0.3;
  # "zen.theme.disable-lightweight" = true; Depracated https://github.com/zen-browser/desktop/issues/9522#issuecomment-3089206722
  "zen.theme.essentials-favicon-bg" = true;
  "zen.theme.gradient" = true;
  "zen.theme.gradient.show-custom-colors" = false;
  "zen.theme.hide-tab-throbber" = true;
  "zen.theme.show-custom-colors" = true;
  "zen.theme.styled-status-panel" = false;
  "zen.theme.use-sysyem-colors" = false;
  "zen.theme.use-system-colors" = false;

  "zen.urlbar.behavior" = "normal";
  "zen.urlbar.replace-newtab" = true;

  "zen.view.compact.enable-at-startup" = false;
  "zen.view.compact.hide-tabbar" = true;
  "zen.view.compact.hide-toolbar" = true;
  "zen.view.experimental-no-window-controls" = true;
  "zen.view.sidebar-expanded" = false;
  "zen.view.use-single-toolbar" = true;

  "zen.glance.enabled" = false;
  "zen.tabs.show-newtab-vertical" = false;

  "privacy.userContext.enabled" = false;
  "privacy.userContext.ui.enabled" = false;

  "zen.watermark.enabled" = false;
  "zen.welcome-screen.seen" = lock-true;
  "zen.widget.linux.transparency" = false; # Disable transparent sidebar
}
