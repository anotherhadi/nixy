{pkgs, ...}: {
  programs.brave = {
    enable = true;
    commandLineArgs = [
      # Wayland Native
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"

      # Hardware Acceleration (NVIDIA optimized)
      "--enable-accelerated-video-decode"
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"

      # Performance
      "--enable-features=VaapiVideoDecoder"
      "--enable-features=VaapiVideoEncoder"
      "--enable-features=CanvasOopRasterization"
      "--disable-features=UseChromeOSDirectVideoDecoder"

      # Privacy & Security
      "--disable-features=MediaRouter" # Disable Chromecast
      "--disable-features=OptimizationHints" # No Google suggestions
      "--disable-features=AutofillSavePaymentMethods"
      "--disable-background-networking" # No telemetry
      "--disable-sync" # Manual sync control

      # Wayland-specific fixes
      "--disable-features=WaylandWpColorManagerV1" # Color management fix

      # UI/UX
      "--force-dark-mode" # Match Stylix theme
      "--enable-features=WebUIDarkMode"
      "--no-default-browser-check"
    ];
    extensions = let
      ids = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
        "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
        "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # privacy badger
        "ghmbeldphafepmbegfdlkpapadhbakde" # proton pass
        "mmjbdbjnoablegbkcklggeknkfcjkjia" # custom new tab page
      ];
    in
      map (id: {inherit id;}) ids;
  };

  xdg.configFile."BraveSoftware/Brave-Browser/Policies/managed/policy.json".text = builtins.toJSON {
    BraveShieldsAdControl = 2;
    BraveShieldsTrackersBlocked = 1;
    BraveShieldsHttpsEverywhere = 1;
    BraveRewardsDisabled = 1;
    BraveWalletDisabled = 1;
    BraveVPNDisabled = 1;
    BraveAIChatEnabled = 0;
    PasswordManagerEnabled = 0;
    BravePlaylistEnabled = 0;
    BraveWebDiscoveryEnabled = 0;
    BraveStatsPingEnabled = 0;
    DnsOverHttpsMode = "automatic";
    BraveDarkMode = 1;
  };

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.brave}/bin/brave";
    BROWSER = "${pkgs.brave}/bin/brave";
  };

  xdg.desktopEntries = {
    brave-incognito = {
      name = "Brave (Private window)";
      genericName = "Navigateur Web";
      exec = "brave --incognito";
      icon = "brave-browser";
      terminal = false;
      categories = ["Network" "WebBrowser"];
      mimeType = ["text/html" "text/xml"];
    };
    brave-tor = {
      name = "Brave (Private window w/Tor)";
      genericName = "Navigateur Web";
      exec = "brave --tor";
      icon = "brave-browser";
      terminal = false;
      categories = ["Network" "WebBrowser"];
    };
  };

  # =================================================================
  #  BRAVE SETTINGS (via brave://flags)
  # =================================================================

  # These need to be set manually in brave://flags on first launch:
  # - Enable Tab Groups (UI)
  # - Enable Parallel Downloading
  # - Enable Reader Mode
  # - GPU Rasterization: Enabled
  # - Override software rendering list: Enabled
  #
  # Privacy settings (brave://settings/privacy):
  # - Block trackers & ads: Aggressive
  # - Block all fingerprinting
  # - Upgrade connections to HTTPS
  # - Block scripts: Off (breaks sites, use uBlock instead)
  # - Block cookies: Only 3rd party
  #
  # Appearance (brave://settings/appearance):
  # - Show home button: Off
  # - Show bookmarks bar: Only on new tab
  # - Use wide address bar: On
}
