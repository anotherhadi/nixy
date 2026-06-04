{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  c = config.lib.stylix.colors;
  rgb = base: map lib.strings.toInt [c."${base}-rgb-r" c."${base}-rgb-g" c."${base}-rgb-b"];

  themeId = "abcadngacjlikcpkhleafekcdjmddegk";
  themeKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6t46VoE3mdV1QNMgybpmQLi5PtYHejnNrSj4DkBZyiTzMzs7Yyvg64f78w3QubZA5cTXSQ7FVhVHvv30I8ym/jNzsSN6reh1t4PtKsFjFRugAty8bfKJGD404HZLOFN2z3G9UPVLBBgzDH3DWbb/kcOq60Mlo/QDCIjsieZg0G3EYMl4efoThzYPWoyv0UEoiliwrE/AChxbgipQetUZ48bFhTCsmnYzCze7clssfTobzWtJJG0qFx76LauHKymRS5OTFfgsovKqHUSFJ202Q53vFdUPP/j8PjSPr1kZeg1NYc7Ba3MoA49EwtJf5ol9oYu05EEnSQ5+1AoYVmdE8QIDAQAB";

  themeManifest = builtins.toJSON {
    manifest_version = 2;
    name = "Stylix Theme";
    version = "1.0";
    key = themeKey;
    theme.colors = {
      frame = rgb "base00";
      frame_inactive = rgb "base00";
      frame_incognito = rgb "base00";
      frame_incognito_inactive = rgb "base00";
      toolbar = rgb "base00";
      toolbar_button_icon = rgb "base05";
      control_background = rgb "base00";
      tab_text = rgb "base0D";
      background_tab = rgb "base00";
      tab_background_text = rgb "base04";
      tab_background_text_inactive = rgb "base04";
      ntp_background = rgb "base00";
      ntp_text = rgb "base05";
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

  originalPkg = (inputs.helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.helium).override {
    flags = heliumFlags;
  };

  patchScript = pkgs.writeShellScript "helium-patch-prefs" ''
    PROFILE="$HOME/.config/net.imput.helium/Default"
    THEME_DIR="$PROFILE/Extensions/${themeId}/1.0_0"
    PREFS="$PROFILE/Preferences"

    mkdir -p "$THEME_DIR"
    rm -f "$THEME_DIR/Cached Theme.pak"
    printf '%s' '${themeManifest}' > "$THEME_DIR/manifest.json"

    if [ -f "$PREFS" ]; then
      tmp=$(mktemp)
      ${lib.getExe pkgs.jq} \
        --arg       id       "${themeId}" \
        --slurpfile manifest "$THEME_DIR/manifest.json" \
        '
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

  baseWrapped = pkgs.symlinkJoin {
    name = "helium-wrapped";
    paths = [originalPkg];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/helium \
        --run ${lib.escapeShellArg (toString patchScript)}
    '';
  };

  wrappedPkg = baseWrapped // {override = _: baseWrapped;};
in {
  imports = [
    inputs.helium-browser.homeModules.default
    ./bookmarks
  ];

  programs.helium = {
    enable = true;
    package = lib.mkForce wrappedPkg;
  };

  home.sessionVariables.BROWSER = "${config.programs.helium.package}/bin/helium";

  xdg.desktopEntries.helium = {
    name = "Helium";
    genericName = "Navigateur Web";
    exec = "${config.programs.helium.package}/bin/helium %U";
    icon = "${config.programs.helium.package}/share/icons/hicolor/256x256/apps/helium.png";
    terminal = false;
    categories = ["Network" "WebBrowser"];
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
    ];
  };

  xdg.desktopEntries.helium-private = {
    name = "Helium (Private window)";
    genericName = "Navigateur Web";
    exec = "${config.programs.helium.package}/bin/helium --incognito %U";
    icon = "${config.programs.helium.package}/share/icons/hicolor/256x256/apps/helium.png";
    terminal = false;
    categories = ["Network" "WebBrowser"];
    mimeType = ["text/html" "text/xml" "application/xhtml+xml"];
  };
}
