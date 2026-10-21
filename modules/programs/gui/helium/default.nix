# Helium browser: wrapped package with a palette theme, policies (system side),
# managed bookmarks and a local startpage (startpage.nix)
{
  aspects,
  inputs,
  config,
  lib,
  ...
}: let
  inherit (config) theme;
  inherit (config.flake.lib) mime;
  bookmarkList = import ./_bookmarks;

  toChromium = items:
    map (item:
      if item ? url
      then {inherit (item) name url;}
      else {
        name = item.name;
        children = toChromium item.bookmarks;
      })
    items;

  themeId = "abcadngacjlikcpkhleafekcdjmddegk";
  themeKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6t46VoE3mdV1QNMgybpmQLi5PtYHejnNrSj4DkBZyiTzMzs7Yyvg64f78w3QubZA5cTXSQ7FVhVHvv30I8ym/jNzsSN6reh1t4PtKsFjFRugAty8bfKJGD404HZLOFN2z3G9UPVLBBgzDH3DWbb/kcOq60Mlo/QDCIjsieZg0G3EYMl4efoThzYPWoyv0UEoiliwrE/AChxbgipQetUZ48bFhTCsmnYzCze7clssfTobzWtJJG0qFx76LauHKymRS5OTFfgsovKqHUSFJ202Q53vFdUPP/j8PjSPr1kZeg1NYc7Ba3MoA49EwtJf5ol9oYu05EEnSQ5+1AoYVmdE8QIDAQAB";

  themeManifest = builtins.toJSON {
    manifest_version = 2;
    name = "Nixy Theme";
    version = "1.0";
    key = themeKey;
    theme.colors = with theme.rgb; {
      frame = base00;
      frame_inactive = base00;
      frame_incognito = base00;
      frame_incognito_inactive = base00;
      toolbar = base00;
      toolbar_button_icon = base05;
      control_background = base00;
      tab_text = base0D;
      background_tab = base00;
      tab_background_text = base04;
      tab_background_text_inactive = base04;
      ntp_background = base00;
      ntp_text = base05;
    };
  };

  heliumFlags = [
    "--ozone-platform=wayland"
    "--enable-features=UseOzonePlatform,VaapiVideoDecoder,VaapiVideoEncoder,CanvasOopRasterization"
    "--disable-features=UseChromeOSDirectVideoDecoder,WaylandWpColorManagerV1"
    "--enable-accelerated-video-decode"
    "--enable-gpu-rasterization"
    "--use-gl=egl"
    "--no-default-browser-check"
    "--show-avatar-button=never"
  ];

  mkHelium = pkgs: let
    originalPkg = (inputs.helium-browser.packages.${pkgs.unstable.stdenv.hostPlatform.system}.helium).override {
      flags = heliumFlags;
    };

    patchScript = pkgs.unstable.writeShellScript "helium-patch-prefs" ''
      PROFILE="$HOME/.config/net.imput.helium/Default"
      THEME_DIR="$PROFILE/Extensions/${themeId}/1.0_0"
      PREFS="$PROFILE/Preferences"

      mkdir -p "$THEME_DIR"
      rm -f "$THEME_DIR/Cached Theme.pak"
      printf '%s' '${themeManifest}' > "$THEME_DIR/manifest.json"

      if [ -f "$PREFS" ]; then
        tmp=$(mktemp)
        ${lib.getExe pkgs.unstable.jq} \
          --arg       id       "${themeId}" \
          --slurpfile manifest "$THEME_DIR/manifest.json" \
          '
            .profile.exit_type                           = "Normal" |
            .profile.exited_cleanly                      = true   |
            .helium.browser.layout                       = 3     |
            .helium.browser.minimal_location_bar        = true  |
            .helium.browser.show_dynamic_new_tab_button = false |
            .helium.browser.rounded_frame               = false |
            .bookmark_bar.show_tab_groups               = false |
            .extensions.settings[$id] = {
              "active_permissions": {"api": [], "explicit_host": [], "manifest_permissions": [], "scriptable_host": []},
              "creation_flags": 0,
              "from_webstore":  false,
              "install_time":   "13300000000000000",
              "location":       1,
              "manifest":       $manifest[0],
              "path":           ($id + "/1.0_0"),
              "state":          1,
              "was_installed_by_default": false,
              "was_installed_by_oem":     false
            } |
            .extensions.theme = {"id": $id, "use_system": false}
          ' "$PREFS" > "$tmp" && mv "$tmp" "$PREFS"
      fi
    '';
  in
    pkgs.unstable.symlinkJoin {
      name = "helium-wrapped";
      paths = [originalPkg];
      nativeBuildInputs = [pkgs.unstable.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/helium \
          --set-default GTK_USE_PORTAL 1 \
          --run ${lib.escapeShellArg (toString patchScript)}
      '';
    };
in {
  flake.modules.nixos.helium = {options, ...}: {
    imports = [
      aspects.hjem
      inputs.helium-browser.nixosModules.default
    ];

    config = lib.mkMerge [
      {
        # Keeps the browser profile in RAM, synced back to disk
        services.psd = {
          enable = true;
          resyncTimer = "10m";
        };

        # System-wide policies (user policies are not read reliably by Chromium)
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

            DnsOverHttpsMode = "automatic";
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

            AutoSelectCertificateForUrls = [
              ''{"pattern":"https://[*.]hadi.icu","filter":{}}'' # Cloudflare mTLS client certificate
            ];

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

        hjem.extraModules = [
          ({
            options,
            pkgs,
            ...
          }: let
            helium = mkHelium pkgs;
            icon = "${helium}/share/icons/hicolor/256x256/apps/helium.png";
          in {
            config = lib.mkMerge [
              {
                packages = [
                  helium
                  (pkgs.makeDesktopItem {
                    name = "helium";
                    desktopName = "Helium";
                    genericName = "Web Browser";
                    exec = "${helium}/bin/helium %U";
                    inherit icon;
                    terminal = false;
                    categories = ["Network" "WebBrowser"];
                    mimeTypes = [
                      "text/html"
                      "text/xml"
                      "application/xhtml+xml"
                      "x-scheme-handler/http"
                      "x-scheme-handler/https"
                      "x-scheme-handler/ftp"
                    ];
                  })
                  (pkgs.makeDesktopItem {
                    name = "helium-private";
                    desktopName = "Helium (Private window)";
                    genericName = "Web Browser";
                    exec = "${helium}/bin/helium --incognito %U";
                    inherit icon;
                    terminal = false;
                    categories = ["Network" "WebBrowser"];
                    mimeTypes = ["text/html" "text/xml" "application/xhtml+xml"];
                  })
                ];

                environment.sessionVariables.BROWSER = "${helium}/bin/helium";
                xdg.mime-apps = mime.defaultFor "helium.desktop" (mime.types.browser ++ mime.types.pdf);

                persist.directories = [
                  ".config/net.imput.helium"
                  ".pki" # NSS database (client certificates)
                ];
              }

              (lib.optionalAttrs (options ? hyprland) {
                hyprland.settings.bind = ["$mod,B, exec, uwsm app -- ${helium}/bin/helium"];
              })
            ];
          })
        ];
      }
    ];
  };
}
