{
  pkgs,
  config,
  ...
}: let
  c = config.lib.stylix.colors;
  # TODO: Waiting for a version in nixpkgs
  version = "1.11.2";
  sources = {
    "x86_64-linux" = {
      url = "https://github.com/elio-fm/elio/releases/download/v${version}/elio-${version}-x86_64-unknown-linux-gnu.tar.gz";
      hash = "sha256-9cW/xUA9p0LEYI3/j4MGPVZvcyJpV1JYKYBuHur4sTM=";
    };
    "aarch64-linux" = {
      url = "https://github.com/elio-fm/elio/releases/download/v${version}/elio-${version}-aarch64-unknown-linux-gnu.tar.gz";
      hash = "sha256-zg141Dp+jHwAqzoaCNvOoC7ZFeAX+cO8HZF5W7wz1Qs=";
    };
  };
  source =
    sources.${pkgs.stdenv.hostPlatform.system}
                    or (throw "elio: unsupported platform ${pkgs.stdenv.hostPlatform.system}");

  elio = pkgs.stdenv.mkDerivation {
    pname = "elio";
    inherit version;

    src = pkgs.fetchurl {inherit (source) url hash;};

    nativeBuildInputs = [pkgs.autoPatchelfHook];

    buildInputs = [pkgs.stdenv.cc.cc.lib];

    installPhase = ''
      runHook preInstall

      install -Dm755 elio -t $out/bin

      for size in 48 128 256 512; do
          install -Dm644 \
              "packaging/linux/icons/hicolor/''${size}x''${size}/apps/elio.png" \
              "$out/share/icons/hicolor/''${size}x''${size}/apps/elio.png"
      done
      install -Dm644 packaging/linux/elio.desktop -t $out/share/applications

      runHook postInstall
    '';

    meta = {
      description = "Terminal file manager";
      homepage = "https://github.com/elio-fm/elio";
      license = pkgs.lib.licenses.mit;
      mainProgram = "elio";
      platforms = builtins.attrNames sources;
      sourceProvenance = [pkgs.lib.sourceTypes.binaryNativeCode];
    };
  };
in {
  home.packages = [elio];

  xdg.desktopEntries.elio = {
    name = "elio";
    exec = "${pkgs.ghostty}/bin/ghostty +new-window -e ${elio}/bin/elio %f";
    terminal = false;
    icon = "elio";
    mimeType = ["inode/directory"];
    categories = ["System" "FileManager" "FileTools" "ConsoleOnly"];
  };

  xdg.configFile."elio/config.toml".text = ''
    [places]
    entries = [
      "home",
      "documents",
      "downloads",
      "pictures",
      { title = "Notes", path = "~/Notes" },
      { title = "Cyber", path = "~/Cyber" },
      { title = "Projects", path = "~/Projects" },
      { title = "NixOS Config", path = "~/.config/nixos" },
      "trash",
    ]
  '';

  xdg.configFile."elio/theme.toml".text = ''
    [palette]
    bg = "#${c.base00}"
    chrome = "#${c.base01}"
    chrome_alt = "#${c.base01}"
    chip_text = "#${c.base00}"
    panel = "#${c.base00}"
    panel_alt = "#${c.base00}"
    surface = "#${c.base02}"
    elevated = "#${c.base02}"
    border = "#${c.base03}"
    text = "#${c.base05}"
    muted = "#${c.base04}"
    accent = "#${c.base0D}"
    accent_soft = "#${c.base02}"
    accent_text = "#${c.base06}"
    selected_bg = "#${c.base02}"
    selected_border = "#${c.base0D}"
    selection_bar = "#${c.base09}"
    yank_bar = "#${c.base0B}"
    cut_bar = "#${c.base08}"
    progress_bar = "#${c.base0D}"
    grid_selection_band = "#${c.base02}"
    grid_yank_band = "#${c.base01}"
    grid_cut_band = "#${c.base01}"
    sidebar_active = "#${c.base02}"
    button_bg = "#${c.base01}"
    button_disabled_bg = "#${c.base01}"
    path_bg = "#${c.base00}"

    [preview.code]
    fg = "#${c.base05}"
    bg = "#${c.base01}"
    selection_bg = "#${c.base02}"
    selection_fg = "#${c.base06}"
    caret = "#${c.base0C}"
    line_highlight = "#${c.base01}"
    line_number = "#${c.base03}"
    comment = "#${c.base03}"
    string = "#${c.base0B}"
    constant = "#${c.base09}"
    keyword = "#${c.base0E}"
    function = "#${c.base0D}"
    type = "#${c.base0A}"
    parameter = "#${c.base08}"
    tag = "#${c.base0C}"
    operator = "#${c.base0C}"
    macro = "#${c.base0F}"
    invalid = "#${c.base08}"
  '';
}
