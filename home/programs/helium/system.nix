{...}: let
  bookmarkList =
    (import ./bookmarks/general.nix)
    ++ (import ./bookmarks/tools.nix)
    ++ (import ./bookmarks/entertainment.nix)
    ++ (import ./bookmarks/infosec.nix)
    ++ (import ./bookmarks/other.nix)
    ++ (import ./bookmarks/jack.nix);

  toChromium = items:
    map (item:
      if item ? url
      then {inherit (item) name url;}
      else {
        name = item.name;
        children = toChromium item.bookmarks;
      })
    items;
in {
  stylix.targets.chromium.enable = false;

  programs.helium = {
    enable = true;

    policies = {
      BrowserSignin = 0;
      SyncDisabled = true;
      SigninAllowed = false;

      PasswordManagerEnabled = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      SafeBrowsingEnabled = false;
      MetricsReportingEnabled = false;
      SpellCheckServiceEnabled = false;
      DefaultCookiesSetting = 1;
      DefaultGeolocationSetting = 2;
      DefaultNotificationsSetting = 2;
      DefaultPopupsSetting = 2;

      DefaultBrowserSettingEnabled = false;
      DeveloperToolsAvailability = 1;

      DnsOverHttpsMode = "secure";
      DnsOverHttpsTemplates = "https://dns.quad9.net/dns-query";

      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "Startpage";
      DefaultSearchProviderSearchURL = "https://www.startpage.com/do/search?q={searchTerms}";
      DefaultSearchProviderSuggestURL = "https://www.startpage.com/do/suggest?q={searchTerms}";

      NewTabPageLocation = "http://127.0.0.1:8888";
      HomepageIsNewTabPage = false;
      HomepageLocation = "http://127.0.0.1:8888";
      ShowHomeButton = false;
      RestoreOnStartup = 4;

      BookmarkBarEnabled = false;
      ManagedBookmarks = toChromium bookmarkList;

      ExtensionInstallForcelist = [
        "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimiu
        "gcknhkkoolaabfmlnjonogaaifnjlfnp" # FoxyProxy
        "ghmbeldphafepmbegfdlkpapadhbakde" # Proton Pass
        "mdjildafknihdffpkfmmpnpoiajfjnjd" # Consent-O-Matic
        "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # Privacy Badger
      ];
    };
  };
}
