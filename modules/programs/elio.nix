# Elio: Snappy, batteries-included TUI file manager.
{
  aspects,
  inputs,
  config,
  lib,
  ...
}: let
  inherit (config.flake.lib) mkSandbox mime;
  c = config.theme.withHashtag;

  # Theme: palette, then file colors. Every file type is colored by its class (the
  # base24 brights give enough distinct accents), so the default theme's per-extension,
  # per-file and per-directory colors are dropped (entries are replaced whole, so
  # their class and icon are kept).
  defaultTheme = builtins.fromTOML (builtins.readFile "${inputs.elio}/assets/themes/default/theme.toml");
  withoutColor = lib.mapAttrs (_: rule: removeAttrs rule ["color"]);
  theme = {
    palette = {
      bg = c.base00;
      chrome = c.base01;
      chrome_alt = c.base01;
      chip_text = c.base00;
      panel = c.base00;
      panel_alt = c.base00;
      surface = c.base02;
      elevated = c.base02;
      border = c.base03;
      text = c.base05;
      muted = c.base04;
      accent = c.base0D;
      accent_soft = c.base02;
      accent_text = c.base06;
      selected_bg = c.base02;
      selected_border = c.base0D;
      selection_bar = c.base09;
      yank_bar = c.base0B;
      cut_bar = c.base08;
      progress_bar = c.base0D;
      grid_selection_band = c.base02;
      grid_yank_band = c.base01;
      grid_cut_band = c.base01;
      sidebar_active = c.base02;
      button_bg = c.base01;
      button_disabled_bg = c.base01;
      path_bg = c.base00;
      trash_bar = c.base12;
      restore_bar = c.base16;
    };

    preview.code = {
      fg = c.base05;
      bg = c.base01;
      selection_bg = c.base02;
      selection_fg = c.base06;
      caret = c.base0C;
      line_highlight = c.base01;
      line_number = c.base03;
      comment = c.base03;
      string = c.base0B;
      constant = c.base09;
      keyword = c.base0E;
      function = c.base0D;
      type = c.base0A;
      parameter = c.base08;
      tag = c.base0C;
      operator = c.base0C;
      macro = c.base0F;
      invalid = c.base08;
    };

    classes = lib.mapAttrs (_: color: {inherit color;}) {
      directory = c.base0D;
      symlink_directory = c.base16;
      broken_symlink = c.base08;
      code = c.base0C;
      config = c.base0E;
      document = c.base0B;
      license = c.base0A;
      image = c.base15;
      audio = c.base09;
      video = c.base17;
      archive = c.base12;
      font = c.base13;
      data = c.base14;
      file = c.base05;
    };

    extensions = withoutColor defaultTheme.extensions;
    files = withoutColor defaultTheme.files;
    directories = withoutColor defaultTheme.directories;
  };
in {
  flake.modules.nixos.elio = {pkgs, ...}: let
    # The portal service spawns the chooser with its own (unsandboxed) binary;
    # let it spawn the sandboxed wrapper instead. Inert when the variable is unset.
    elioPkg = inputs.elio.packages.${pkgs.stdenv.hostPlatform.system}.elio.overrideAttrs (old: {
      postPatch =
        (old.postPatch or "")
        + ''
          substituteInPlace src/portal/service.rs --replace-fail \
            'let executable = match std::env::current_exe() {' \
            'let executable = match std::env::var_os("ELIO_PORTAL_CHOOSER").map(std::path::PathBuf::from).map_or_else(std::env::current_exe, Ok) {'

          # Ghostty only parses `--key=value`: `--title "elio File Chooser"` fails
          # with "title: value required"
          ${pkgs.perl}/bin/perl -0pi -e 's/(Self::Ghostty => vec!\[)\s*"--title"\.into\(\),\s*TITLE\.into\(\),/$1 format!("--title={TITLE}").into(),/' src/portal/terminal.rs
          grep -q 'format!("--title={TITLE}")' src/portal/terminal.rs
        '';
    });

    # Sandboxed: no network, no D-Bus, secrets hidden, NixOS config read-only.
    # Everything elio spawns inherits the sandbox.
    elio = (mkSandbox pkgs).wrap {
      package = elioPkg;
      config = {sloth, ...}: {
        bubblewrap = {
          bind.rw = [sloth.homeDir];
          bind.ro = [
            (sloth.concat' sloth.homeDir "/.config/nixos")
            (sloth.concat' sloth.runtimeDir "/elio/portal") # File chooser socket to the portal service
          ];
          sockets.wayland = true; # wl-copy, GUI apps opened from elio
        };
      };
    };

    # FileChooser portal backend (what `elio portal enable` sets up imperatively).
    # The D-Bus service runs outside the sandbox and opens the sandboxed chooser in ghostty.
    elioPortal = let
      service = pkgs.writeShellScript "elio-portal-service" ''
        export PATH=${pkgs.ghostty}/bin:$PATH
        export ELIO_PORTAL_CHOOSER=${elio}/bin/elio
        exec ${elioPkg}/bin/elio --portal-service
      '';
    in
      pkgs.runCommandLocal "elio-portal" {} ''
        mkdir -p $out/share/xdg-desktop-portal/portals $out/share/dbus-1/services
        cat > $out/share/xdg-desktop-portal/portals/elio.portal <<EOF
        [portal]
        DBusName=io.github.elio_fm.elio.Portal
        Interfaces=org.freedesktop.impl.portal.FileChooser;
        EOF
        cat > $out/share/dbus-1/services/io.github.elio_fm.elio.Portal.service <<EOF
        [D-BUS Service]
        Name=io.github.elio_fm.elio.Portal
        Exec=${service}
        EOF
      '';
  in {
    imports = [aspects.hjem];

    # Browser "select file(s)" and "save download to..." dialogs
    xdg.portal = {
      # Key MUST use the "impl" interface name, else xdg-desktop-portal
      # ignores it and falls back to the default (gtk). See portals.conf(5).
      config.hyprland."org.freedesktop.impl.portal.FileChooser" = ["elio"];
      extraPortals = [elioPortal];
    };

    hjem.extraModules = [
      ({lib, ...}: {
        packages = [
          elio
          pkgs.poppler-utils # PDF previews
          pkgs.ffmpeg # media metadata and thumbnails
          pkgs.resvg # SVG previews
          (lib.hiPrio (pkgs.makeDesktopItem {
            name = "elio";
            desktopName = "Files";
            exec = "${pkgs.ghostty}/bin/ghostty +new-window -e ${elio}/bin/elio %f";
            terminal = false;
            mimeTypes = ["inode/directory"];
            categories = ["System" "FileManager" "FileTools" "ConsoleOnly"];
            keywords = ["elio" "file" "explorer"];
          }))
        ];

        # Default file manager and archive handler
        xdg.mime-apps = mime.defaultFor "elio.desktop" (mime.types.directory ++ mime.types.archive);

        files = {
          ".config/elio/config.toml".text = ''
            [places]
            show_devices = false
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

            [portal]
            terminal = "ghostty"
          '';

          ".config/elio/theme.toml".source = (pkgs.formats.toml {}).generate "elio-theme.toml" theme;
        };
      })
    ];
  };
}
